/**
 * @filename MobileLocationController.java
 */
package com.maogousoft.wuliuweb.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.util.Assert;

import com.jfinal.plugin.activerecord.Db;
import com.maogousoft.wuliuweb.common.BaseConfig;
import com.maogousoft.wuliuweb.common.BaseController;
import com.maogousoft.wuliuweb.common.WuliuConstants;
import com.maogousoft.wuliuweb.common.exception.BusinessException;
import com.maogousoft.wuliuweb.common.utils.JSONUtils;
import com.maogousoft.wuliuweb.common.utils.TimeUtil;
import com.maogousoft.wuliuweb.domain.Business;
import com.maogousoft.wuliuweb.domain.Driver;
import com.maogousoft.wuliuweb.domain.GoldResult;
import com.maogousoft.wuliuweb.domain.Msg;
import com.maogousoft.wuliuweb.domain.User;
import com.maogousoft.wuliuweb.service.MobileLocationService;
import com.maogousoft.wuliuweb.service.PushService;
import com.maogousoft.wuliuweb.service.PushService2;

/**
 * @description 手机定位
 * @author shevliu
 * @email shevliu@gmail.com
 * May 13, 2013 11:00:48 PM
 */
public class MobileLocationController extends BaseController{

	/**
	 * 每次定位收费
	 */
	private static final double LOCATION_COST = 0.2 ;

	public void index(){
		User user = User.dao.findById(getUserId());
		double gold = user.getDouble("gold") == null ? 0 :  user.getDouble("gold");
		if(gold < LOCATION_COST){
			renderJson(JSONUtils.toMsgJSONString("余额不足，无法定位，请充值再进行定位", false));
			return ;
		}
		String mobile = getPara("mobile") ;
		Assert.hasText(mobile);
		Map<String, String> queryResult = MobileLocationService.queryUser(mobile, "");
		//已加入白名单
		if("1".equals(queryResult.get("lststate"))){
			Map<String, String> locationResult = MobileLocationService.location(mobile);
			if("1".equals(queryResult.get("result"))){
				System.out.println(locationResult);
				double x = NumberUtils.toDouble(locationResult.get("X"));
				double y = NumberUtils.toDouble(locationResult.get("Y"));
				String address = locationResult.get("address");
				String sql = "update logistics_driver set longitude = ? , latitude = ? ,  last_position =? , last_position_time = ? where phone = ? " ;
				Db.update(sql , x, y , address , new Date() , mobile);
				GoldResult gr = user.adjustGold(-LOCATION_COST);
				user.update();
				Business.dao.addUserBusiness(getUserId(), Business.BUSINESS_TYPE_LOCATION, LOCATION_COST, 0, 0);
				Msg.dao.addUserMsg(Msg.TYPE_BUSINIESS, "手机定位扣费", "手机定位成功，扣除费用:" + LOCATION_COST, getUserId());
				renderJson(JSONUtils.toJson(locationResult, true));
			}
			else{
				renderJson(JSONUtils.toMsgJSONString("定位失败，请稍候再试", false));
			}
		}
		//还未加入白名单
		else{
			//向用户发起申请
			Map<String, String> regResult = MobileLocationService.registUser(mobile, "");
			System.out.println("向用户发起申请" + regResult);
			renderJson(JSONUtils.toMsgJSONString("该手机号还未同意定位要求，请等待.司机也可以主动编辑短信Y，移动发送至10658012174，联通发送至106550101832224261", false));
		}
	}

	/**
	 * 免费定位
	 * @throws JSONException
	 */
	public void freeLocation() throws JSONException{
		long beginTime = getParaToLong("beginTime" , 0L);
		if(beginTime == 0){
			beginTime = System.currentTimeMillis();
		}
		User user = User.dao.findById(getUserId());
		if(user == null) {
			throw new BusinessException("请先登录.");
		}
		String mobile = getPara("mobile");
		Assert.hasText(mobile);
		String order_id = getPara("order_id");

		Driver driver = Driver.dao.findByPhone(mobile);
		if(driver == null) {
			renderJson(JSONUtils.toJson("该用户尚未注册易运宝,暂时无法定位.", false));
			return;
//			throw new BusinessException("该用户尚未注册易运宝,暂时无法定位.");
		}
		Date last_position_time = driver.asDate("last_position_time");

		//如果没有更新,或者更新时间大于所设置的间隔
		if(last_position_time == null || (System.currentTimeMillis() - last_position_time.getTime() >= 60000)) { //一分钟后才允许再次定位
			//推送给司机
			int driver_id = driver.getInt("id");
			JSONObject json = new JSONObject();
			if(StringUtils.isNotBlank(order_id)) {
				json.put("order_id", order_id);
			}
			json.put("msg_type", WuliuConstants.PUSH_MSG_TYPE_DRIVER_REPORT_LOCATION);
//			PushService.pushSysMsgByDriverId(new int[] {driver_id}, json.toString(), WuliuConstants.PUSH_MSG_TYPE_DRIVER_REPORT_LOCATION);
			PushService2.pushSysMsgByDriverId(new int[] {driver_id}, json.toString());
		}

		//如果轮询的时候发现距离上次定位时间小于30秒，表示本次定位成功，返回经纬度
		if(last_position_time != null && (System.currentTimeMillis() - last_position_time.getTime() <= 30000)) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("X", driver.asDoubleValue("longitude", WuliuConstants.DEFAULT_LOCATION_LONGITUDE));
			map.put("Y", driver.asDoubleValue("latitude", WuliuConstants.DEFAULT_LOCATION_LATITUDE));
			map.put("driverName", driver.getStr("name"));
			map.put("address", driver.getStr("last_position"));
			map.put("timestamp", last_position_time == null? "暂无" : TimeUtil.format(last_position_time,"yyyy-MM-dd HH:mm:ss"));
			renderJson(JSONUtils.toJson(map, true));
		}else {
			//客户端轮询。 当首次定位时（beginTime=0）或者距离首次定位时间在30秒内，就认为还在定位
			Map<String, Object> map = new HashMap<String, Object>();
			if(beginTime == 0 || (System.currentTimeMillis() - beginTime) < 30000){
				try {
					//休息5秒
					Thread.sleep(5000);
				} catch (InterruptedException e) {
				}
				map.put("beginTime", beginTime);
				map.put("done", false);
			}
			//否则认为超时
			else{
				map.put("done", true);
			}
			renderJson(JSONUtils.toJson(map, false));
		}
	}
}
