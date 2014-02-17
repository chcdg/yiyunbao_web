/**
 * @filename InsuranceController.java
 */
package com.maogousoft.wuliuweb.controller;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.maogousoft.wuliuweb.common.BaseController;
import com.maogousoft.wuliuweb.common.domain.MiniData;
import com.maogousoft.wuliuweb.common.utils.JSONUtils;
import com.maogousoft.wuliuweb.common.utils.TimeUtil;
import com.maogousoft.wuliuweb.domain.Business;
import com.maogousoft.wuliuweb.domain.Dict;
import com.maogousoft.wuliuweb.domain.GoldResult;
import com.maogousoft.wuliuweb.domain.InsuranceCargoType;
import com.maogousoft.wuliuweb.domain.Msg;
import com.maogousoft.wuliuweb.domain.User;

/**
 * @description 货运保险
 * @author shevliu
 * @email shevliu@gmail.com
 * Apr 30, 2013 10:07:32 PM
 */
public class InsuranceController extends BaseController{

	private static final Logger log = LoggerFactory.getLogger(InsuranceController.class);

	public void index(){
		render("insurance.ftl");
	}

	public void cpic() {
		User user = User.dao.loadUserById(getUserId());
		setAttr("user", user);
		render("cpic_add.ftl");
	}

	public void save_cpic() {
		try {
			User user = User.dao.loadUserById(getUserId());

			String insurer_name = getPara("insurer_name");
			String insured_name = getPara("insured_name");
			String insurer_phone = getPara("insurer_phone");
			String insured_phone = getPara("insured_phone");
			String shiping_number = getPara("shiping_number");
			String cargo_desc = getPara("cargo_desc");
			String packet_number = getPara("packet_number");
			String ship_type = getPara("ship_type");
			String ship_tool = getPara("ship_tool");
			String plate_number = getPara("plate_number");
//			int start_province = getAsInt("start_province", -1);
//			int start_city = getAsInt("start_city", -1);
//			int start_district = getAsInt("start_district", -1);
//			int end_province = getAsInt("end_province", -1);
//			int end_city = getAsInt("end_city", -1);
//			int end_district = getAsInt("end_district", -1);
			Date start_date = getAsDate("start_date", "yyyy-MM-dd", null);
			double amount_covered = getAsDouble("amount_covered", 0);
			int insurance_type = getAsInt("insurance_type", 1);//保险类型,1-基本险，2-综合险，3-综合险附加被盗险(万分之5)
			double ratio = insurance_type == 1? 0.03 : (insurance_type == 2 ? 0.04 : 0.05); //费率
			Date sign_time = getAsDate("sign_time", "yyyy-MM-dd", null);
			Date create_time = new Date();
			String create_user = getUserId() + "";

			double insurance_charge = amount_covered * ratio / 100;//保险费
			if(insurance_charge < 20){
				insurance_charge = 20 ;
			}
			
			String start_area = getPara("start_area");
			String end_area = getPara("end_area");
			int package_type = getParaToInt("package_type");
			int cargo_type1 = getParaToInt("cargo_type1");
			int cargo_type2 = getParaToInt("cargo_type2");
			String receipt_title = getPara("receipt_title");

			Record record = new Record();
			record.set("insurer_name", insurer_name);
			record.set("insured_name", insured_name);
			record.set("insurer_phone", insurer_phone);
			record.set("insured_phone", insured_phone);
			record.set("shiping_number", shiping_number);
			record.set("cargo_desc", cargo_desc);
			record.set("packet_number", packet_number);
			record.set("ship_type", ship_type);
			record.set("ship_tool", ship_tool);
			record.set("plate_number", plate_number);
//			record.set("start_province", start_province);
//			record.set("start_city", start_city);
//			record.set("start_district", start_district);
//			record.set("end_province", end_province);
//			record.set("end_city", end_city);
//			record.set("end_district", end_district);
			record.set("start_date", start_date);
			record.set("amount_covered", amount_covered);
			record.set("insurance_type", insurance_type);
			record.set("ratio", ratio);
			record.set("insurance_charge", insurance_charge);
			record.set("sign_time", sign_time);
			record.set("create_time", create_time);
			record.set("create_user", create_user);
			record.set("start_area", start_area);
			record.set("end_area", end_area);
			record.set("package_type", package_type);
			record.set("cargo_type1", cargo_type1);
			record.set("cargo_type2", cargo_type2);
			record.set("receipt_title", receipt_title);
			
			Db.save("logistics_insure", record);

			GoldResult gr = user.adjustGold(-insurance_charge);
			Business.dao.addUserBusiness(getUserId(), Business.BUSINESS_TYPE_AWARD, insurance_charge, gr.getBeforeGold(), gr.getAfterGold());

			Msg.dao.addUserMsg(Msg.TYPE_INSURANCE, "提交保单成功", "提交保单成功,保单号:" + record.get("id") + ",投保运单号:" + shiping_number, getUserId());
			Msg.dao.addUserMsg(Msg.TYPE_BUSINIESS, "保险费用扣除", "提交保单成功,保单号:" + record.get("id") + ",扣除保险费用:" + insurance_charge, getUserId());

			renderJson(JSONUtils.toMsgJSONString("提交保单成功,保单号：" + record.get("id"), true));
		} catch (Exception e) {
			log.error("提交保单失败:" + e.getMessage(), e);
			renderJson(JSONUtils.toMsgJSONString("提交保单失败，请稍候再试", false));
		}
	}

	private void setIfAbsent(Record record, String columnName, Object defaultValue) {
		if(record.get(columnName) == null || StringUtils.isBlank(String.valueOf(record.get(columnName)))) {
			record.set(columnName, defaultValue);
		}
	}

	private Date getAsDate(String name, String format, Date defaultValue) {
		String str = getPara(name);
		if(str == null) {
			return defaultValue;
		}
		return TimeUtil.parse(str, format, defaultValue);
	}

	private double getAsDouble(String name, double defaultValue) {
		String str = getPara(name);
		if(str == null) {
			return defaultValue;
		}
		return NumberUtils.toDouble(str, defaultValue);
	}

	private int getAsInt(String name, int defaultValue) {
		String str = getPara(name);
		if(str == null) {
			return defaultValue;
		}
		return NumberUtils.toInt(str, defaultValue);
	}
	
	/**
	 * 
	 * @description 获取货物类别一级分类 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * 2013年9月5日 上午12:27:04
	 */
	public void getFirstCargoType(){
		List<InsuranceCargoType> list = InsuranceCargoType.dao.getAllFirstType();
		String json  = JSONUtils.toJSONString(list, "id|name");
		renderJson(json);
	}
	
	/**
	 * 
	 * @description 获取货物类别二级分类 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * 2013年9月5日 上午12:27:04
	 */
	public void getSecondCargoType(){
		int pid = getParaToInt("id");
		List<InsuranceCargoType> list = InsuranceCargoType.dao.getSecondFirstType(pid);
		String json  = JSONUtils.toJSONString(list, "id|name");
		renderJson(json);
	}
}
