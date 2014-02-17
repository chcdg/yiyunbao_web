/**
 * @filename VerifyController.java
 */
package com.maogousoft.wuliuweb.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.StringUtils;

import sun.misc.BASE64Decoder;

import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.maogousoft.wuliuweb.common.BaseConfig;
import com.maogousoft.wuliuweb.common.BaseController;
import com.maogousoft.wuliuweb.common.utils.JSONUtils;
import com.maogousoft.wuliuweb.common.utils.TimeUtil;
import com.maogousoft.wuliuweb.domain.Business;
import com.maogousoft.wuliuweb.domain.Fleet;
import com.maogousoft.wuliuweb.domain.IdCard;
import com.maogousoft.wuliuweb.domain.Msg;
import com.maogousoft.wuliuweb.domain.User;
import com.maogousoft.wuliuweb.service.FileInfo;
import com.maogousoft.wuliuweb.service.ImageService;
import com.maogousoft.wuliuweb.service.credentials.IdCardService;

/**
 * @description 证件验证
 * @author shevliu
 * @email shevliu@gmail.com Apr 30, 2013 8:54:04 PM
 */
public class VerifyController extends BaseController {

	private static final Log log = LogFactory.getLog(VerifyController.class);
	
	/**
	 * 验证费用
	 */
	private static final double ID_CARD_PRICE = 5;

	public void index() {
		int userId = getUserId();
		User user = User.dao.loadUserById(userId);
		setAttr("user", user);
		render("verify.ftl");
	}

	/**
	 * 
	 * @description 验证身份证
	 * @author shevliu
	 * @email shevliu@gmail.com Apr 30, 2013 9:35:24 PM
	 */
	@Before(Tx.class)
	public void verifyIdCard() {
		Map<String, String> result = new HashMap<String, String>();
		
		int userId = getUserId();
		User user = User.dao.findById(userId);
		
		double gold = user.getDouble("gold") ;
		if(gold < ID_CARD_PRICE){
			throw new RuntimeException("余额不足");
//			renderJson(JSONUtils.toMsgJSONString("余额不足", false));
//			return ;
		}
		
		Record record = getMiniData().getRecord();
		Map<String, String> map = IdCardService.validate(record
				.getStr("id_card"), record.getStr("id_name"));
		log.debug("身份验证结果：" + map);
		if (!map.get("status").equals("0")
				|| NumberUtils.toInt(map.get("errorcode"))>0) {
			throw new RuntimeException("身份验证失败，稍候再试");
//			renderJson(JSONUtils.toMsgJSONString("身份验证失败，稍候再试", false));
//			return;
		} else {
			
			try {
			String photo = map.get("photo");
			String idPhoto = "" ;
			String regioninfo = map.get("regioninfo");
			Date birthday = TimeUtil.parse(map.get("birthday"), "yyyy/MM/dd", null);
			int gender = NumberUtils.toInt(map.get("gender") , -1) ;
			String genderStr = "未知";
			if(gender ==0){
				genderStr = "女";
			}
			else if(gender == 1){
				genderStr = "男";
			}
			if (StringUtils.hasText(photo)) {
				String uploadBasePath = BaseConfig.me().getProperty("upload.basepath");
				BASE64Decoder decoder = new BASE64Decoder();
					String fileName = "idcard_" + System.currentTimeMillis() + ".jpg";
					File file = new File(uploadBasePath + File.separator + fileName);
					FileOutputStream write = new FileOutputStream(file);
					 byte[] decoderBytes = decoder.decodeBuffer(photo);
				     write.write(decoderBytes);
				     write.flush();
				     write.close();
				     FileInfo fileInfo = ImageService.saveFile(fileName, file);
					 idPhoto = fileInfo.getVirtualUrl();
					 IdCard idCard = new IdCard();
					 idCard.set("u_id", "u" + userId);
					 idCard.set("id_card", record.getStr("id_card"));
					 idCard.set("id_name", record.getStr("id_name"));
					 idCard.set("photo", idPhoto);
					 idCard.set("create_time", new Date());
					 idCard.set("status", map.get("verifyresult").equals("1"));
					 idCard.set("regioninfo", regioninfo);
					 idCard.set("birthday", birthday);
					 idCard.set("gender", gender);
					 idCard.save();
				
			}
			user.set("gold", gold - ID_CARD_PRICE) ;
			user.update();
			Business.dao.addUserBusiness(userId, Business.BUSINESS_TYPE_VERIFY, ID_CARD_PRICE, 0, 0);
			Msg.dao.addUserMsg(Msg.TYPE_BUSINIESS, "验证身份证成功", "验证身份证成功，扣除费用:" + ID_CARD_PRICE, getUserId());
			
			result.put("verifyresult", map.get("verifyresult"));
			if (map.get("verifyresult").equals("1")) {
				result.put("msg", "身份验证一致，并且有照片");
				result.put("photo", idPhoto);
				result.put("id_name", record.getStr("id_name"));
				result.put("id_num", record.getStr("id_card"));
				result.put("regioninfo", regioninfo == null ? "&nbsp;" : regioninfo);
				result.put("gender", genderStr);
				if(birthday != null){
					result.put("id_year", TimeUtil.format(birthday, "yyyy"));
					result.put("id_month", TimeUtil.format(birthday, "M"));
					result.put("id_day", TimeUtil.format(birthday, "d"));
				}
				else{
					result.put("id_year", "&nbsp;");
					result.put("id_month", "&nbsp;");
					result.put("id_day", "&nbsp;");
				}
			} else if (map.get("verifyresult").equals("2")) {
				result.put("msg", "身份验证不一致");
			} else if (map.get("verifyresult").equals("3")) {
				result.put("msg", "库中无此号码");
			} else if (map.get("verifyresult").equals("4")) {
				renderJson(JSONUtils.toMsgJSONString("身份验证一致，但是无照片", true));
				result.put("msg", "身份验证一致，但是无照片");
				result.put("id_name", record.getStr("id_name"));
				result.put("id_num", record.getStr("id_card"));
				result.put("regioninfo", regioninfo == null ? "&nbsp;" : regioninfo);
				result.put("gender", genderStr);
				if(birthday != null){
					result.put("id_year", TimeUtil.format(birthday, "yyyy"));
					result.put("id_month", TimeUtil.format(birthday, "M"));
					result.put("id_day", TimeUtil.format(birthday, "d"));
				}
				else{
					result.put("id_year", "&nbsp;");
					result.put("id_month", "&nbsp;");
					result.put("id_day", "&nbsp;");
				}
			}
			setAttr("result", result);
			render("verify_result.ftl");
//			renderJson(JSONUtils.toJson(result, true));
			} catch (Exception e) {
				log.error("验证失败" , e);
//				renderJson(JSONUtils.toMsgJSONString("验证失败，稍候再试", false));
			}
		}
	}
	
	public void test(){
		render("verify_result2.ftl");
	}
	
	/**
	 * 
	 * @description 身份验证历史 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Jun 2, 2013 9:30:12 PM
	 */
	public void idCardHistory(){
		render("id_card.ftl");
	}
	
	/**
	 * 
	 * @description 查询身份验证列表 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Jun 2, 2013 9:29:33 PM
	 */
	public void queryIdCardList(){
		String uId = "u" + getUserId() ;
		String select  = "select * ";
		String from = " from logistics_idcard where u_id = ? order by id desc" ;
		Page<IdCard> page = IdCard.dao.paginate(getPageIndex(), getPageSize(), select , from ,uId);
		String field = "id|id_card|id_name|photo|create_time|status|regioninfo|birthday|gender";
		renderJson(JSONUtils.toPagedGridJSONString(page, field));
	}

	/**
	 * 
	 * @description 验证驾驶证
	 * @author shevliu
	 * @email shevliu@gmail.com Apr 30, 2013 9:42:26 PM
	 */
	public void verifyJSZ() {
		log.info(getMiniData().getRecord());
		renderJson(JSONUtils.toMsgJSONString("成功", true));
	}

	/**
	 * 
	 * @description 验证行驶证
	 * @author shevliu
	 * @email shevliu@gmail.com Apr 30, 2013 9:42:33 PM
	 */
	public void verifyXSZ() {
		log.info(getMiniData().getRecord());
		renderJson(JSONUtils.toMsgJSONString("成功", true));
	}
}
