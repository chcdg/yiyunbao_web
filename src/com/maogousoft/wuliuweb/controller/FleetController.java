/**
 * @filename FleetController.java
 */
package com.maogousoft.wuliuweb.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.List;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.joda.time.DateTime;
import org.springframework.util.StringUtils;

import com.jfinal.aop.Before;
import com.jfinal.core.JFinal;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.jfinal.upload.UploadFile;
import com.maogousoft.wuliuweb.common.BaseController;
import com.maogousoft.wuliuweb.common.domain.MiniData;
import com.maogousoft.wuliuweb.common.utils.CookieUtil;
import com.maogousoft.wuliuweb.common.utils.ExcelUtil;
import com.maogousoft.wuliuweb.common.utils.JSONUtils;
import com.maogousoft.wuliuweb.common.utils.MD5Util;
import com.maogousoft.wuliuweb.domain.Area;
import com.maogousoft.wuliuweb.domain.Business;
import com.maogousoft.wuliuweb.domain.Dict;
import com.maogousoft.wuliuweb.domain.Driver;
import com.maogousoft.wuliuweb.domain.Fleet;
import com.maogousoft.wuliuweb.domain.Msg;
import com.maogousoft.wuliuweb.domain.User;
import com.maogousoft.wuliuweb.service.SmsService;

/**
 * @description 我的车队
 * @author shevliu
 * @email shevliu@gmail.com
 * Apr 30, 2013 12:14:42 PM
 */
public class FleetController extends BaseController{
	
	private static final Log log = LogFactory.getLog(FleetController.class);
	
	public static final String CAR_LENGTH1 = "3-6.8";
	public static final String CAR_LENGTH2 = "6.9-9.6";
	public static final String CAR_LENGTH3 = "9.7-13";
	public static final String CAR_LENGTH4 = "13以上";
	public static final String BUXIAN = "不限";
	public static final String CAR_WEIGHT1= "1-5";
	public static final String CAR_WEIGHT2 = "5-10";
	public static final String CAR_WEIGHT3 = "10-15";
	public static final String CAR_WEIGHT4 = "15-20";
	public static final String CAR_WEIGHT5 = "20以上";

	/**
	 * 
	 * @description 列表页面 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 30, 2013 12:32:19 PM
	 */
	public void index(){
		render("cars_online.ftl");
	}
	
	/**
	 * 
	 * @description 网上车场列表查询 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 30, 2013 12:32:13 PM
	 */
	public void list(){
		String start_province = getPara("start_province");
		String end_province = getPara("end_province");
		String last_position = getPara("last_position");
		String car_type = getPara("car_type");
		String car_length = getPara("car_length");
		String car_weight = getPara("car_weight");
		String driver_attest = getPara("driver_attest");
		
		String select = "select driver.*,";
		select += "dict.name as type_name,a1.name as start_province_name,a2.name as start_city_name,";
		select +=	"a3.name as end_province_name,a4.name as end_city_name";
		StringBuffer from = new StringBuffer();
		from.append(" from logistics_driver driver left join logistics_dict dict on driver.car_type = dict.id");
		from.append(" left join logistics_area a1  on driver.start_province = a1.id");
		from.append(" left join logistics_area a2 on driver.start_city = a2.id");
		from.append(" left join logistics_area a3 on driver.end_province = a3.id");
		from.append(" left join logistics_area a4 on driver.end_city = a4.id");
//		from.append(" left join logistics_fleet fleet on driver.phone = fleet.phone");
		from.append(" where 1=1 ");
		//出发省
		if(StringUtils.hasText(start_province)){
//			from.append(" and driver.start_province ="+start_province) ;
			from.append(" and (driver.start_province ="+start_province+" or driver.start_province2="+start_province+" or driver.start_province3="+start_province+")") ;
		}
		//目的省
		if(StringUtils.hasText(end_province)){
//			from.append(" and driver.end_province ="+end_province) ;
			from.append(" and (driver.end_province ="+end_province+" or driver.end_province2="+end_province+" or driver.end_province3="+end_province+")") ;
		}
		//车辆位置
		if(StringUtils.hasText(last_position)){
			from.append(" and driver.last_position like '%" + last_position + "%'") ;
		}
		//车型
		if(StringUtils.hasText(car_type)){
			if("43".equals(car_type)){
				from.append("") ;
			}else{
				from.append(" and driver.car_type ="+car_type) ;
			}
		}
		//车长
		if(StringUtils.hasText(car_length)){
			if(CAR_LENGTH1.equals(car_length)){
				from.append(" and driver.car_length between 3 and 6.8") ;
			}else if(CAR_LENGTH2.equals(car_length)){
				from.append(" and driver.car_length between 6.9 and 9.6") ;
			}else if(CAR_LENGTH3.equals(car_length)){
				from.append(" and driver.car_length between 9.7 and 13") ;
			}else if(CAR_LENGTH4.equals(car_length)){
				from.append(" and driver.car_length > 13") ;
			}else{
				from.append("");
			}
		}
		//车重
		if(StringUtils.hasText(car_weight)){
			if(CAR_WEIGHT1.equals(car_weight)){
				from.append(" and driver.car_weight between 1 and 5") ;
			}else if(CAR_WEIGHT2.equals(car_weight)){
				from.append(" and driver.car_weight between 5 and 10") ;
			}else if(CAR_WEIGHT3.equals(car_weight)){
				from.append(" and driver.car_weight between 10 and 15") ;
			}else if(CAR_WEIGHT4.equals(car_weight)){
				from.append(" and driver.car_weight between 15 and 20") ;
			}else if(CAR_WEIGHT5.equals(car_weight)){
				from.append(" and driver.car_weight >20") ;
			}else{
				from.append("");
			}
		}
		//有无照片
		if(StringUtils.hasText(driver_attest)){
			if("1".equals(driver_attest)){
				from.append(" and driver.status = 1") ;
			}else{
				from.append(" and driver.status = 0 or driver.status = 2") ;
			}
		}
		from.append(" and driver.is_private <> 1");
		from.append(" order by driver.last_position_time desc ");
		
		Page<Record> page = Db.paginate(getPageIndex(), getPageSize(), select, from.toString());
		renderText(JSONUtils.toPagedGridJSONStringUsingRecord(page));
	}
	
	/**
	 * 添加数据到我的车队
	 */
	public void addTOMyCars(){
		String ids = getPara();
		String[] orderIds = ids.split(",");
		for(int i=0;i<orderIds.length;i++){
			Driver driver = Driver.dao.findById(orderIds[i]);
			String phone = driver.getStr("phone");
			int userId = getUserId();
			List<Fleet> list = Fleet.dao.find("select * from logistics_fleet t where t.phone="+phone+" and t.user_id = "+userId);
			if(list.size() > 0){
				if(orderIds.length == 1){
					renderText("您的车队中已存在此司机。姓名："+list.get(0).get("driver_name")+"，  手机号码："+list.get(0).get("phone"));
					return;
				}
				continue;
			}
			Fleet fleet = new Fleet();
			fleet.set("user_id", getUserId());
			fleet.set("phone", driver.get("phone"));
			fleet.set("driver_name", driver.get("name"));//司机姓名
			fleet.set("cphm", driver.get("plate_number"));
			String start_province = driver.get("start_province")+"";
			fleet.set("start_province", start_province);
			String start_city = driver.get("start_city")+"";
			fleet.set("start_city", start_city);
			String end_province = driver.get("end_province")+"";
			fleet.set("end_province", end_province);
			String end_city = driver.get("end_city")+"";
			fleet.set("end_city", end_city);
			fleet.set("driver_status", driver.getInt("status"));
			fleet.set("car_type", driver.getInt("car_type"));
			fleet.set("car_length", driver.get("car_length"));
			fleet.set("car_weight", driver.getInt("car_weight"));
//			fleet.set("owner_phone", driver.getStr("owner_phone"));//车主电话
			fleet.set("remark", driver.get("remark"));
			fleet.save();
			renderText("操作已经成功.");
		}
	}
	
	/**
	 * 我的车队
	 */
	public void myFleetList(){
		render("my_fleet.ftl");
	}
	
	/**
	 * 查询我的车队数据
	 */
	public void queryMyCarList(){
		int userId = getUserId();
		String start_province = getPara("start_province");
		String end_province = getPara("end_province");
		String phone = getPara("phone");
		String last_position = getPara("last_position");
		String car_type = getPara("car_type");
		String car_length = getPara("car_length");
		String car_weight = getPara("car_weight");
//		String driver_attest = getPara("driver_attest");
		
		String select = "select f.*,d.name as driver_name,d.last_position as last_position_name,d.last_position_time as last_position_time,";
		select += "a1.name as start_city_name,a2.name as end_city_name,";
		select += "d2.name as type_name";
		StringBuffer from = new StringBuffer();
		from.append(" from logistics_fleet f");
		from.append(" left join logistics_driver d on f.phone = d.phone");
		from.append(" left join logistics_dict d2 on f.car_type = d2.id");
		from.append(" left join logistics_area a1 on d.start_city = a1.id");
		from.append(" left join logistics_area a2 on d.end_city = a2.id");
		from.append(" where 1=1");
		//出发省
		if(StringUtils.hasText(start_province)){
			from.append(" and (d.start_province ="+start_province+" or d.start_province2="+start_province+" or d.start_province3="+start_province+")") ;
		}
		//目的省
		if(StringUtils.hasText(end_province)){
			from.append(" and (d.end_province ="+end_province+" or d.end_province2="+end_province+" or d.end_province3="+end_province+")") ;
		}
		//电话号码
		if(StringUtils.hasText(phone)){
			from.append(" and d.phone ="+phone);
		}
		//车辆位置
		if(StringUtils.hasText(last_position)){
			from.append(" and d.last_position like '%" + last_position + "%'") ;
		}
		//车型
		if(StringUtils.hasText(car_type)){
				from.append(" and d.car_type ="+car_type) ;
		}
		//车长
		if(StringUtils.hasText(car_length)){
			if(CAR_LENGTH1.equals(car_length)){
				from.append(" and d.car_length between 3 and 6.8") ;
			}else if(CAR_LENGTH2.equals(car_length)){
				from.append(" and d.car_length between 6.9 and 9.6") ;
			}else if(CAR_LENGTH3.equals(car_length)){
				from.append(" and d.car_length between 9.7 and 13") ;
			}else if(CAR_LENGTH4.equals(car_length)){
				from.append(" and d.car_length > 13") ;
			}else{
				from.append("");
			}
		}
		//车重
		if(StringUtils.hasText(car_weight)){
			if(CAR_WEIGHT1.equals(car_weight)){
				from.append(" and d.car_weight between 1 and 5") ;
			}else if(CAR_WEIGHT2.equals(car_weight)){
				from.append(" and d.car_weight between 5 and 10") ;
			}else if(CAR_WEIGHT3.equals(car_weight)){
				from.append(" and d.car_weight between 10 and 15") ;
			}else if(CAR_WEIGHT4.equals(car_weight)){
				from.append(" and d.car_weight between 15 and 20") ;
			}else if(CAR_WEIGHT5.equals(car_weight)){
				from.append(" and d.car_weight >20") ;
			}else{
				from.append("");
			}
		}
		
		from.append(" and f.user_id = ?");
		from.append(" order by d.last_position_time desc");
		
		Page<Record> page = Db.paginate(getPageIndex(), getPageSize(), select, from.toString(),userId);
		renderText(JSONUtils.toPagedGridJSONStringUsingRecord(page));
	}
	
	/**
	 * 发送短信
	 */
	public void sendMgs(){
		String phone = getPara("phone");
		List<Driver> driverList = Driver.dao.find("select * from logistics_driver where phone="+phone);
		Driver driver = driverList.get(0);
		List<Dict> dictList = Dict.dao.find("select * from logistics_dict where dict_type='car_type' and id="+driver.getInt("car_type"));
		Dict dict = null;
		if(dictList.size() != 0){			
			dict = dictList.get(0);
			setAttr("car_type",dict.get("name"));
		}
		setAttr("driver",driver);
		render("msgEdit.ftl");
	}
	
	/**
	 * 发送司机资料到
	 */
	@Before(Tx.class)
	public void sendMsgTo(){
		try {
			String phone = getPara("phone");
			String content = getPara("content");
			
			double cost = phone.length() * 0.1 ;  //每条消息0.1物流币
			int userId = getUserId() ;
			User user = User.dao.findById(userId);
			double gold = user.getDouble("gold") ;
			if(gold < cost){
				renderJson(JSONUtils.toMsgJSONString("余额不足", false));
				return ;
			}
			double beforeMoney = gold ;
			double afterMoney = gold - cost;
			//扣费
			user.set("gold", afterMoney) ;
			user.update();
			//记录交易信息
			Business.dao.addDriverBusiness(userId, Business.BUSINESS_TYPE_SMS, cost, beforeMoney, afterMoney);
			SmsService.send(phone, content);
			Msg.dao.addUserMsg(Msg.TYPE_BUSINIESS, "发送短信扣费", "发送短信成功，扣除费用:" + cost, userId);
			renderJson(JSONUtils.toMsgJSONString("发送短信成功", true));
		} catch (Exception e) {
			log.error("发送短信失败：", e);
			renderJson(JSONUtils.toMsgJSONString("发送短信失败", false));
		}
		
		
	}
	
	
	/**
	 * 
	 * @description 新增页面
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 30, 2013 2:15:14 PM
	 */
	public void add(){
		render("fleet_add.ftl");
	}
	
	public void save(){
		try{
			int userId = getUserId();
			MiniData data = getMiniData();
			Record record = data.getRecord() ;
			record.set("user_id", userId);
			record.remove("id");
			String sql1 = "select * from logistics_fleet where phone = ? and user_id = ?";
			List<Record> fleet_list = Db.find(sql1,record.get("phone"),getUserId());
			if(fleet_list.size() > 0){
				renderJson(JSONUtils.toMsgJSONString("随车手机已存在", false));
				return;
			}else{
				Db.save("logistics_fleet", record);
			}
			
			//当司机已经存在driver表时，不做添加操作
			String sql2 = "select * from logistics_driver where phone = ? or car_phone = ?";
			List<Record> driver_list = Db.find(sql2,record.get("phone"),record.get("phone"));
			if(driver_list.size() > 0){
				
			}else{
				Driver driver = new Driver();
				driver.set("phone", record.get("phone"));
				driver.set("plate_number", record.get("cphm"));
				driver.set("name", record.get("driver_name"));
				driver.set("id_card", record.get("id_card"));
				driver.set("start_province", record.get("start_province"));
				driver.set("start_city", record.get("start_city"));
				driver.set("end_province", record.get("end_province"));
				driver.set("end_city", record.get("end_city"));
				driver.set("car_type", record.get("car_type"));
				driver.set("car_length", record.get("car_length"));
				driver.set("start_province2", record.get("start_province2"));
				driver.set("start_city2", record.get("start_city2"));
				driver.set("end_province2", record.get("end_province2"));
				driver.set("end_city2", record.get("end_city2"));
				driver.set("start_province3", record.get("start_province3"));
				driver.set("start_city3", record.get("start_city3"));
				driver.set("end_province3", record.get("end_province3"));
				driver.set("end_city3", record.get("end_city3"));
				driver.set("is_private", 1);
				driver.save();
			}
			renderJson(JSONUtils.toMsgJSONString("添加成功", true));
		}catch(RuntimeException re){
			log.error("添加我的车队失败" , re);
			renderJson(JSONUtils.toMsgJSONString("添加失败，请稍候再试", false));
		}
	}
	
	/**
	 * 
	 * @description 查看我的车队详情
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 30, 2013 3:38:48 PM
	 */
	public void myFleetDetail(){
		int id = getParaToInt();
		Fleet fleet = Fleet.dao.findFirst("select a.* ,c.name as car_type_name from logistics_fleet a  left join logistics_dict c on a.car_type = c.id  where a.id = ? " , id);
		Driver driver = Driver.dao.findFirst("select * from logistics_driver where phone = ?" , fleet.getStr("phone"));
		setAttr("regist", true);
		if(driver == null){
			driver = new Driver();
			driver.set("longitude", 116.403119);
			driver.set("latitude", 39.915156);
			setAttr("regist", false);
		}
		setAttr("fleet", fleet);
		setAttr("driver", driver);
		render("my_fleet_detail.ftl");
	}
	
	/**
	 * 网上车场司机详情查看
	 */
	public void online_cars_detail(){
		int id = getParaToInt();
		StringBuffer sql = new StringBuffer();
		sql.append("select d.*,d2.name as type_name,");
		sql.append("a1.short_name as start_province_name, a2.short_name as start_city_name,");
		sql.append("a3.short_name as end_province_name, a4.short_name as end_city_name,");
		sql.append("a5.short_name as start_province2_name, a6.short_name as start_city2_name,");
		sql.append("a7.short_name as end_province2_name, a8.short_name as end_city2_name,");
		sql.append("a9.short_name as start_province3_name, a10.short_name as start_city3_name,");
		sql.append("a11.short_name as end_province3_name, a12.short_name as end_city3_name");
		sql.append(" from logistics_driver d left join logistics_dict d2 on d.car_type=d2.id");
		sql.append(" left join logistics_area a1 on d.start_province = a1.id left join logistics_area a2 on d.start_city = a2.id");
		sql.append(" left join logistics_area a3 on d.end_province = a3.id left join logistics_area a4 on d.end_city = a4.id");
		sql.append(" left join logistics_area a5 on d.start_province2 = a5.id left join logistics_area a6 on d.start_city2 = a6.id");
		sql.append(" left join logistics_area a7 on d.end_province2 = a7.id left join logistics_area a8 on d.end_city2 = a8.id");
		sql.append(" left join logistics_area a9 on d.start_province3 = a9.id left join logistics_area a10 on d.start_city3 = a10.id");
		sql.append(" left join logistics_area a11 on d.end_province3 = a11.id left join logistics_area a12 on d.end_city3 = a12.id");
		sql.append(" where d.id ="+id);
		Driver driver = Driver.dao.findFirst(sql.toString());
		
		setAttr("driver", driver);
		render("online_car_detail.ftl");
	}
	
	/**
	 * 
	 * @description 批量发送短信 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 17, 2013 9:29:03 PM
	 */
	@Before(Tx.class)
	public void sms(){
		try{
			String mobile = getPara("phones");
			String content = getPara("content");
			String[] phones = mobile.split(",");
			double cost = phones.length * 0.1 ;  //每条消息0.1物流币
			int userId = getUserId() ;
			User user = User.dao.findById(userId);
			double gold = user.getDouble("gold") ;
			if(gold < cost){
				renderJson(JSONUtils.toMsgJSONString("余额不足", false));
				return ;
			}
			double beforeMoney = gold ;
			double afterMoney = gold - cost;
			//扣费
			user.set("gold", afterMoney) ;
			user.update();
			//记录交易信息
			Business.dao.addDriverBusiness(userId, Business.BUSINESS_TYPE_SMS, cost, beforeMoney, afterMoney);
			SmsService.send(mobile, content);
			Msg.dao.addUserMsg(Msg.TYPE_BUSINIESS, "发送短信扣费", "发送短信成功，扣除费用:" + cost, userId);
			renderJson(JSONUtils.toMsgJSONString("发送短信成功", true));
		}catch(RuntimeException re){
			log.error("发送短信失败：", re);
			renderJson(JSONUtils.toMsgJSONString("发送短信失败", false));
		}
	}
	
	public void invitSMSInit(){
		String mobile = getPara("phone");
		int userId = getUserId() ;
		User user = User.dao.findById(userId);
		String content = user.getStr("company_name") + " 邀请您免费注册易运宝会员，大量真实货源，随时随地随您挑！请点击 http://url.cn/G5elvc 即可下载安装，如有疑问，请致电4008765156.";
		setAttr("content",content);
		setAttr("mobile",mobile);
		render("fleet_invit_sms.ftl");
	}
	
	/**
	 * 
	 * @description 邀请注册短信，免费 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Jun 19, 2013 11:59:12 PM
	 */
	public void invitSMS(){
		try{
			String mobile = getPara("phones");
			String content = getPara("content");
			//记录交易信息
			SmsService.send(mobile, content);
			renderJson(JSONUtils.toMsgJSONString("发送短信成功", true));
		}catch(RuntimeException re){
			log.error("发送短信失败：", re);
			renderJson(JSONUtils.toMsgJSONString("发送短信失败", false));
		}
	}
	
	public void delete(){
		try{
			int id = getParaToInt();
			Fleet fleet = Fleet.dao.findById(id);
			if(fleet.getInt("user_id") == getUserId()){
				Fleet.dao.deleteById(id);
			}
			renderJson(JSONUtils.toMsgJSONString("成功", false));
		}catch(RuntimeException re){
			log.error("删除我的车队失败：", re);
			renderJson(JSONUtils.toMsgJSONString("删除失败", false));
		}
	}
	
	public void edit(){
		int id = getParaToInt();
		Fleet fleet = Fleet.dao.findById(id);
		if(fleet.getInt("user_id") == getUserId()){
			setAttr("fleet", fleet);
			render("fleet_edit.ftl");
		}
		else{
			renderHtml("没有权限");
		}
	}
	
	public void update(){
		try{
			int userId = getUserId();
			MiniData data = getMiniData();
			Record record = data.getRecord() ;
			int fleetId = NumberUtils.toInt(record.getStr("id") , 0) ;
			Fleet fleet = Fleet.dao.findById(fleetId);
			if(fleet.getInt("user_id") == getUserId()){
				record.set("id", fleetId);
				record.set("user_id", userId);
				Db.update("logistics_fleet", record);
				renderJson(JSONUtils.toMsgJSONString("修改成功", true));
			}
			else{
				renderHtml("没有权限");
			}
			
		}catch(RuntimeException re){
			log.error("添加我的车队失败" , re);
			renderJson(JSONUtils.toMsgJSONString("添加失败，请稍候再试", false));
		}
	}
	
	public void importUser(){
		render("import_user.ftl");
	}
	
	/**
	 * 批量导入司机
	 */
	public void importUsers(){
		render("import_users.ftl");
	}
	
	public void doImportUser(){
		try{
			int userId = getUserId();
			MiniData data = getMiniData();
			Record record = data.getRecord() ;
			Driver driver = Driver.dao.findFirst("select * from logistics_driver where phone = ?",record.getStr("phone"));
			if(driver == null){
				renderJson(JSONUtils.toMsgJSONString("导入司机失败:司机未注册", false));
				return;
			}
			Dict.fillDictToModel(driver);
			Fleet fleet = new Fleet();
			fleet.set("user_id", userId);
			fleet.set("phone", driver.get("phone"));
			fleet.set("cphm", driver.get("plate_number"));
			fleet.set("driver_name", driver.get("name"));
			fleet.set("car_type", driver.get("car_type"));
			fleet.set("car_length", driver.get("car_length"));
			fleet.set("car_weight", driver.get("car_weight"));
			fleet.set("car_width", 0);
			fleet.set("car_height", 0);
			fleet.set("car_bulk", 0);
			fleet.set("driver_id_card", driver.get("id_card"));
			fleet.set("driver_jszz", driver.get("license"));
			String qwlx = driver.getStr("end_province_name") == null ? "" :  driver.getStr("end_province_name") ;
			qwlx += driver.getStr("end_city_name") == null ? "" : driver.getStr("end_city_name") ;
			qwlx += driver.getStr("end_district_name") == null ? "" : driver.getStr("end_district_name") ;
			fleet.set("qwlx", qwlx);
			fleet.save();
			renderJson(JSONUtils.toMsgJSONString("导入成功", true));
		}catch(RuntimeException re){
			log.error("导入失败我的车队失败" , re);
			renderJson(JSONUtils.toMsgJSONString("导入失败，请稍候再试", false));
		}
	}

	/**
	 * 上传司机文件
	 */
	public void uploadDriverFile(){
		String savePath=JFinal.me().getServletContext().getRealPath("/")+"driver_upload";
		UploadFile  upFile = getFile("file", savePath);
		String path = savePath.replace('\\', '/');
		String str = path+"/"+upFile.getFileName();
		try {
			CookieUtil.addCookie(getResponse(), "filePath", URLEncoder.encode(str,"UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		render("import_users.ftl");
	}
	
	public void batchImportDriver(){
		int user_id = getUserId();
		String path = null;
		String str = CookieUtil.getCookie(getRequest(), "filePath");
		try {
			path = URLDecoder.decode(str,"UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		CookieUtil.clearCookie(getRequest(),getResponse(),"filePath");
		batchSaveDriver(path,user_id);
	}
	public void batchSaveDriver(String filePath,int user_id){
		//读取出excel文件的数据
		List<String[]> field = new ExcelUtil().readXls(filePath);
		if(field.size() > 0){
			Driver driver;
//			Area area;
			for (int i = 0;i<field.size();i++) {
				driver = new Driver();
				String[] str = field.get(i);
				List<Record> sql_list = null;
				//获取地址对应的id
				initDriverArea(driver, "end_province", str[3]);
				if(str[4] != null && !"".equals(str[4].trim())){
					initDriverArea(driver, "end_city", str[4]);
				}
				initDriverArea(driver, "end_province2", str[14]);
				if(str[15] != null && !"".equals(str[15].trim())){
					initDriverArea(driver, "end_city2", str[15]);
				}
				initDriverArea(driver, "end_province3", str[18]);
				if(str[19] != null && !"".equals(str[19].trim())){
					initDriverArea(driver, "end_city3", str[19]);
				}
				initDriverArea(driver, "start_province", str[5]);
				if(str[6] != null && !"".equals(str[6].trim())){
//					area = Area.getAreaByName(str[6]);
					initDriverArea(driver, "start_city", str[6]);
				}
				initDriverArea(driver, "start_province2", str[12]);
				if(str[13] != null && !"".equals(str[13].trim())){
					initDriverArea(driver, "start_city2", str[13]);
				}
				initDriverArea(driver, "start_province3", str[16]);
				if(str[17] != null && !"".equals(str[17].trim())){
					initDriverArea(driver, "start_city3", str[17]);
				}
				String sql;
				//判断电话号码是否重复
				if((str[2] != null && !"".equals(str[2])) || (str[20] != null && !"".equals(str[20]))){
//					sql = "select count(1) as count_num from logistics_driver where phone in (?,?) or car_phone in (?,?)";
//					count += Db.findFirst(sql,str[2],str[20],str[2],str[20]).getLong("count_num");
					sql = "select * from logistics_driver t where t.phone = ? or t.car_phone = ?";
					sql_list = Db.find(sql,str[2],str[2]);
					if(sql_list.size() > 0){
//						 continue;
					}
				}
				//身份证是否重复
				if(str[10] != null && !"".equals(str[10].trim())){
					sql = "select * from logistics_driver where id_card = ?";
					sql_list = Db.find(sql,str[10]);
					if(sql_list.size() > 0){
//						 continue;
					}
				}
				//车牌号码是否重复
//				if(str[0] != null && !"".equals(str[0].trim())){
//					sql = "select * from logistics_driver where plate_number = ?";
//					sql_list = Db.find(sql,str[0]);
//					if(sql_list.size() > 0){
////						 continue;
//					}
//				}
				if(str[7] != null && !"".equals(str[7].trim())){
					sql = "select id from logistics_dict where name=? and dict_type = 'car_type'";
					Record r = Db.findFirst(sql, str[7]);
					long carTypeId = r != null ? r.getNumber("id").longValue():0;
					driver.set("car_type", carTypeId);
				}
				if(str[8] != null && !"".equals(str[8].trim())){
					String length = str[8];
					if(str[8].indexOf("米") != -1){
						length = str[8].replace("米", "");
					}
					driver.set("car_length",length);
				}
				if(str[9] != null && !"".equals(str[9].trim())){
					String weight = str[9];
					if(str[9].indexOf("吨") != -1){
						weight = str[9].replace("吨", "");
					}
					driver.set("car_weight",weight);
				}
				
				if(sql_list.size() > 0){
					String phone = str[2];
					driver = Driver.dao.findByPhone(phone);
				}else{		
					driver.set("plate_number", str[0]).
					set("name", str[1]).
					set("password",MD5Util.MD5("666666")).
					set("phone", str[2]).
					set("id_card", str[10]).
					set("license", str[11]).
					set("owner_phone", str[20]);
					driver.set("is_private",1);
					driver.save(); 
				}
				
				List<Fleet> list = Fleet.dao.find("select * from logistics_fleet where phone ="+str[2]+" and user_id="+user_id);
				if(list.size() > 0){
					renderText("司机["+driver.getStr("name")+"]["+driver.getStr("phone")+"]已存在，请检查后再试.");
					return;
				}else{
					//添加到司机表的同时，也添加到车队表
					Fleet fleet = new Fleet();
					fleet.set("user_id", user_id);
					fleet.set("phone", driver.get("phone"));
					fleet.set("driver_name", driver.get("name"));
					fleet.set("cphm", driver.get("plate_number"));
					fleet.set("driver_status", driver.getInt("status"));
					fleet.set("car_type", driver.get("car_type"));
					fleet.set("car_length", driver.get("car_length"));
					fleet.set("car_weight", driver.get("car_weight"));
					fleet.set("remark", driver.get("remark"));
					fleet.save();
				}
			}
		}
//		return JSONUtils.toMsgJSONString("司机导入成功！",true);
		renderText("操作已成功.");
	}
	
	//查询路线的id
	public void initDriverArea(Driver driver,String where,String areaName){
		Area area;
		if(areaName != null && !"".equals(areaName.trim())){
			area = Area.getAreaByName(areaName);
			long id = area != null?area.getNumber("id").longValue():0;
			driver.set(where, id);
		}
	}
	
	public void trajectory(){
		String phone = getPara("phone");
		DateTime now = new DateTime().minusDays(7);
		String sql = "select a.* from logistics_order_location a ,logistics_driver b where a.driver_id=b.id and b.phone=? and create_time >= ? order by a.id" ;
		List<Record> list = Db.find(sql , phone , now.toDate());
		StringBuffer sb = new StringBuffer();
		for (Record point : list) {
			sb.append("new BMap.Point(");
			sb.append(point.getBigDecimal("longitude"));
			sb.append(",");
			sb.append(point.getBigDecimal("latitude"));
			sb.append("),");
		}
		if (list.size() > 0) {
			setAttr("points", sb.toString().substring(0, sb.length() - 1));
			log.debug("points:" + sb.toString().substring(0, sb.length() - 1));
		}
		setAttr("list", list);
		render("../order/trajectory.ftl");
	}
	
	public static void main(String args[]){
		DateTime now = new DateTime().minusDays(7);
		System.out.println(now.toDate());
	}
}
