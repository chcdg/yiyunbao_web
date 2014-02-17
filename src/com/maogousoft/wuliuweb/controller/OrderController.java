/**
 * @filename OrderController.java
 */
package com.maogousoft.wuliuweb.controller;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONException;

import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.jfinal.upload.UploadFile;
import com.maogousoft.wuliuweb.common.BaseConfig;
import com.maogousoft.wuliuweb.common.BaseController;
import com.maogousoft.wuliuweb.common.UserUtil;
import com.maogousoft.wuliuweb.common.exception.BusinessException;
import com.maogousoft.wuliuweb.common.utils.JSONUtils;
import com.maogousoft.wuliuweb.common.utils.TimeUtil;
import com.maogousoft.wuliuweb.domain.Business;
import com.maogousoft.wuliuweb.domain.Dict;
import com.maogousoft.wuliuweb.domain.Driver;
import com.maogousoft.wuliuweb.domain.DriverReply;
import com.maogousoft.wuliuweb.domain.GoldResult;
import com.maogousoft.wuliuweb.domain.Msg;
import com.maogousoft.wuliuweb.domain.Order;
import com.maogousoft.wuliuweb.domain.OrderLog;
import com.maogousoft.wuliuweb.domain.OrderTemplet;
import com.maogousoft.wuliuweb.domain.OrderVie;
import com.maogousoft.wuliuweb.domain.User;
import com.maogousoft.wuliuweb.service.FileInfo;
import com.maogousoft.wuliuweb.service.ImageService;
import com.maogousoft.wuliuweb.service.SmsService;

/**
 * @description 订单
 * @author shevliu
 * @email shevliu@gmail.com
 * Mar 17, 2013 7:03:19 PM
 */
public class OrderController extends BaseController {

	private static final Log log = LogFactory.getLog(OrderController.class) ;

	/**
	 *
	 * @description 待定货单
	 */
	public void pendingList(){
		render("pendingList.ftl");
	}

	/**
	 * 进行中的货单
	 */
	public void dealList(){
		render("dealList.ftl");
	}

	/**
	 * 历史订单
	 */
	public void historyList() {
		render("historyList.ftl");
	}

	/**
	 * 查询订单记录
	 */
	public void queryOrderLog() {
		int orderId = getParaToInt();

		//订单操作信息
		List<Record> orderLogs = Db.find("select * from log_order where order_id=?", orderId);
		Page<Record> page = Db.paginate(1, 1000, "select *", "from log_order where order_id=?", orderId);
		setAttr("orderLogs", orderLogs);
		renderText(JSONUtils.toPagedGridJSONStringUsingRecord(page));
	}
	
	/**
	 * 添加货单模板
	 */
	public void addOrderTemplet(){
		List<Map<String, Object>> list = (List<Map<String, Object>>) JSONUtils.Decode(getPara("data"));
		Map<String, Object> map = list.get(0);
		
		String templet_name = getPara("templetName");
		if(null == templet_name || "".equals(templet_name)){
			renderText("请输入模板名称.");
			return;
		}
		//添加模板前，先查看模板名称是否已经存在
		List<OrderTemplet> otlist = OrderTemplet.dao.findOrderTempletByName(templet_name,getUserId());
		//每个用户最多只能拥有5个模板
		List<OrderTemplet> temlist = OrderTemplet.dao.findOrderTempletByUserId(getUserId());
		if(otlist.size() > 0){
			String tpName = otlist.get(0).get("templet_name");
			renderHtml("模板名称 <span style='color:red'>"+tpName+"</span> 已存在，请重新输入.");
			return;
		}
		if(templet_name.length() >10){
			renderText("亲，模板名称太长，最多5个汉字.");
			return;
		}
		if(temlist.size() > 4){
			renderText("亲，每个用户最多只能拥有5个模板喔.");
			return;
		}
		
		String start_province = (String) map.get(("start_province"));
		String start_province_name = (String) map.get(("start_province_name"));
		String start_city = (String) map.get(("start_city"));
		String start_city_name = (String) map.get(("start_city_name"));
		String start_district = (String) map.get(("start_district"));
		String start_district_name = (String) map.get(("start_district_name"));
		String end_province = (String) map.get(("end_province"));
		String end_province_name = (String) map.get(("end_province_name"));
		String end_city = (String) map.get(("end_city"));
		String end_city_name = (String) map.get(("end_city_name"));
		String end_district = (String) map.get(("end_district"));
		String end_district_name = (String) map.get(("end_district_name"));
		//货物名称
		String cargo_desc = (String) map.get("cargo_desc");
		//货物类型
		String cargo_type = (String) map.get("cargo_type");
		if(null != cargo_type && !"".equals(cargo_type.trim())){			
			Dict.verifyDict("cargo_type", Integer.parseInt(cargo_type));
		}
		//运输方式
		String ship_type = map.get("ship_type")+"";
//		if(null != ship_type){			
//			Dict.verifyDict("ship_type",ship_type);
//		}
		//体积重量
		String cargo_number = map.get("cargo_number")+"";//货物数量
		String cargo_unit = map.get("cargo_unit")+"";//货物数量单位
		//价格
		String unitprice = map.get("unit_price")+"";
		double unit_price = Double.parseDouble(unitprice);
		double price = unit_price * Double.parseDouble(cargo_number);//总价
		//车长
		String carlength = map.get("car_length")+"" ;
		double car_length = Double.parseDouble(carlength);
		//车型
		String car_type = (String) map.get("car_type");
//		if(null != car_type && !"".equals(car_type.trim())){			
//			Dict.verifyDict("car_type", Integer.parseInt(car_type));
//		}
		//装车时间
		String loadingtime = map.get("loading_time")+"";
		String loadingtime1 = loadingtime.replace("T", " ");
		Date loading_time = TimeUtil.parse(loadingtime1, "yyyy-MM-dd HH:mm:ss", null);
		//保证金
		Integer user_bond = (Integer) map.get("user_bond");
		//货单说明
		String cargo_remark = (String) map.get("cargo_remark");
		//货单有效时间
		String validatetime = map.get("validate_time")+"";
		Date validate_time = new Date(Long.parseLong(validatetime));
//		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//		String str = sdf.format(validate_time);
		//联系人和联系电话
		String cargo_user_name = (String) map.get("cargo_user_name");
		String cargo_user_phone = (String) map.get("cargo_user_phone");
		
		OrderTemplet ot = new OrderTemplet();
		ot.set("user_id", getUserId());
		ot.set("start_province", start_province);
		ot.set("start_province_name", start_province_name);
		if(null != start_city && !"".equals(start_city)){			
			ot.set("start_city", start_city);
			ot.set("start_city_name", start_city_name);
		}
		if(null != start_district && !"".equals(start_district)){			
			ot.set("start_district", start_district);
			ot.set("start_district_name", start_district_name);
		}
		ot.set("end_province", end_province);
		ot.set("end_province_name", end_province_name);
		if(null != end_city && !"".equals(end_city)){			
			ot.set("end_city", end_city);
			ot.set("end_city_name", end_city_name);
		}
		if(null != end_district && !"".equals(end_district)){			
			ot.set("end_district", end_district);
			ot.set("end_district_name", end_district_name);
		}
		ot.set("cargo_desc", cargo_desc);
		if(null != cargo_type && !"".equals(cargo_type)){
			ot.set("cargo_type", cargo_type);
		}
		ot.set("ship_type", ship_type);
		ot.set("cargo_number", cargo_number);
		ot.set("cargo_unit", cargo_unit);
		ot.set("unit_price", unit_price);
		ot.set("price", price);
		ot.set("car_length", car_length);
		if(null != car_type && !"".equals(car_type)){			
			ot.set("car_type", Integer.parseInt(car_type));
		}
		ot.set("loading_time", loading_time);
		ot.set("user_bond", user_bond);
		ot.set("cargo_remark", cargo_remark);
		ot.set("cargo_user_name", cargo_user_name);
		ot.set("cargo_user_phone", cargo_user_phone);
		ot.set("validate_time", validate_time);
		ot.set("create_time", new Date());
		ot.set("templet_name", templet_name);
		ot.save();
		renderText("操作已成功.");
	}
	
	public void findOrderTempletByUserId(){
		List<OrderTemplet> list = OrderTemplet.dao.findOrderTempletByUserId(getUserId());
		List tempNameList = new ArrayList<String>();
		for(int i=0;i<list.size();i++){
			tempNameList.add(list.get(i).get("templet_name"));
		}
		renderJson(tempNameList);
	}
	
	public void findOrderTempletByName(){
		String templet_name = getPara("tem_name");
		List<OrderTemplet> list = OrderTemplet.dao.findOrderTempletByName(templet_name,getUserId());
		OrderTemplet ot = list.get(0);
		renderJson(ot);
	}
	
	public void delOrderTempletByName(){
		String templet_name = getPara("tem_name");
		OrderTemplet.dao.delTempletOrderByName(templet_name,getUserId());
	}

	/**
	 * 发布货单
	 */
	public void publishOrder(){
		User user = User.dao.loadUserById(getUserId());
		setAttr("user", user);
		render("publishOrder.ftl");
	}

	@Before(Tx.class)
	public void doPublishOrder() {

		UploadFile uf = getFile("cargo_photo1");

		String start_province = getPara("start_province_id");
		String start_city = getPara("start_city_id");
		String start_district = getPara("start_district_id");
		String end_province = getPara("end_province_id");
		String end_city = getPara("end_city_id");
		String end_district = getPara("end_district_id");
		//货物名称
		String cargo_desc = getPara("cargo_desc");
		//联系人及联系电话
		String cargo_user_name = getPara("cargo_user_name");
		String cargo_user_phone = getPara("cargo_user_phone");
		//货物类型
		String cargo_type = getPara("cargo_type");
		if(null != cargo_type && !"0".equals(cargo_type.trim()) && !"".equals(cargo_type.trim())){			
			Dict.verifyDict("cargo_type", Integer.parseInt(cargo_type));
		}
		//车长
		double car_length = NumberUtils.toDouble(getPara("car_length") , 0) ;
		//货物数量+重量
//		String cargo_number_str = getPara("cargo_number");//货物数量
		double cargo_number = NumberUtils.toDouble(getPara("cargo_number") , 0);
		String cargo_unit_str = getPara("cargo_unit");//货物数量单位
		int cargo_unit_int = 0;
//		if(null != cargo_number_str && !"".equals(cargo_number_str.trim())){
//			cargo_number = Double.parseDouble(cargo_number_str);
//		}
		if(null != cargo_unit_str && !"".equals(cargo_unit_str.trim())){
			cargo_unit_int = Integer.parseInt(cargo_unit_str);
		}
		//价格
		Double unit_price = NumberUtils.toDouble(getPara("unit_price") , 0);//货物单价
		Double price = unit_price * cargo_number;//总价
		//运输方式
		String ship_type = getPara("ship_type");
		if(null != ship_type && !"0".equals(ship_type.trim()) && !"".equals(ship_type.trim())){			
			Dict.verifyDict("ship_type", Integer.parseInt(ship_type));
		}
		//车辆类型
		String car_type = getPara("car_type");
		if(null != car_type && !"0".equals(car_type.trim()) && !"".equals(car_type.trim())){			
			Dict.verifyDict("car_type", Integer.parseInt(car_type));
		}

		Date loading_time = TimeUtil.parse(getPara("loading_time"), "yyyy-MM-dd HH:mm:ss", null);
		String cargo_remark = getPara("cargo_remark");
		Date validate_time = new Date(getParaToLong("validate_time"));

		Double user_bond = Double.valueOf(getPara("user_bond","0.0"));

		String receipt_password = getPara("receipt_password");

		//校验保证金
		User user = User.dao.findById(getUserId());
		Double gold = user.getDouble("gold");
		if(gold == null || (gold < user_bond)) {
			renderHtml("余额" + gold + "不足以支付保证金与信息费,共计<b>" + user_bond + "</b>请先<a href=\"/pay\" target=\"_blank\">充值</a>");
			return;
		}

		Order order = new Order();
		order.set("user_id", getUserId());
		order.set("start_province", start_province);
		if(null != start_city && !"".equals(start_city)){			
			order.set("start_city", start_city);
		}
		if(null != start_district && !"".equals(start_district)){			
			order.set("start_district", start_district);
		}
		order.set("end_province", end_province);
		if(null != end_city && !"".equals(end_city)){			
			order.set("end_city", end_city);
		}
		if(null != end_district && !"".equals(end_district)){			
			order.set("end_district", end_district);
		}
		order.set("cargo_desc", cargo_desc);
		if(null != cargo_type && !"".equals(cargo_type.trim())){			
			order.set("cargo_type", cargo_type);
		}
		order.set("car_length", car_length);
		order.set("cargo_number", cargo_number);
		order.set("cargo_unit", cargo_unit_int);
		if(null != cargo_user_name && !"".equals(cargo_user_name)){
			order.set("cargo_user_name", cargo_user_name);
		}
		if(null != cargo_user_phone && !"".equals(cargo_user_phone)){
			order.set("cargo_user_phone", cargo_user_phone);
		}
		order.set("unit_price", unit_price);
		order.set("price", price);
		if(null != ship_type && !"".equals(ship_type.trim())){			
			order.set("ship_type", ship_type);
		}
		if(null != car_type && !"".equals(car_type.trim())){			
			order.set("car_type", car_type);
		}
		if(uf != null) {
			FileInfo fileInfo = ImageService.saveFile(uf.getFileName(), uf.getFile());
			String cargo_photo1 = fileInfo.getVirtualUrl();
			order.set("cargo_photo1", cargo_photo1);
		}
//		order.set("cargo_photo2", cargo_photo2);
//		order.set("cargo_photo3", cargo_photo3);
		order.set("loading_time", loading_time);
		order.set("cargo_remark", cargo_remark);
		order.set("validate_time", validate_time);//有效日期为当前时间+有效时间数量
		order.set("user_bond", user_bond);
		order.set("create_time", new Date());
		order.set("push_drvier_count", 0); //推送给相关司机数量（需等审核通过后才能推送）
		order.set("receipt_password", receipt_password);
		order.save();

		//扣除保证金
		GoldResult gr = user.adjustGold(-user_bond);

		//扣除后给货主发送信息
		Business.dao.addUserBusiness(getUserId(), Business.BUSINESS_TYPE_DEPOSIT, user_bond, gr.getBeforeGold(), gr.getAfterGold());
		Msg.dao.addUserMsg(Msg.TYPE_BUSINIESS, "保证金扣除", "发布货源，扣除保证金:" + user_bond, getUserId());

		//记录订单信息
		OrderLog.logOrder(order.getInt("id"), "货主[" + user.getStr("name") + "]", "发布订单.");

		//跳转到设置回单密码界面
		setAttr("order", order);
		render("receipt_ok.ftl");
	}

	/**
	 * 历史订单查询
	 */
	public void queryHistoryList(){

		String beginDate = getPara("beginDate");
		String endDate = getPara("endDate");
		String startPoint = getPara("start_point");
		String endPoint = getPara("end_point");
		String status = getPara("status");
		String cargo_desc = getPara("cargo_desc");
		String plate_number = getPara("plate_number");

		String select = "select a.*, k.phone as driver_phone ,k.name as driver_name ,";
		select += " k.longitude,k.latitude,k.plate_number ";

		StringBuffer from = new StringBuffer();
		from.append(" from logistics_order a ");
		from.append(" left join logistics_driver k on a.driver_id = k.id ");
		from.append(" where a.user_id=? ");
		from.append(createAndUsingInt("a.car_type:car_type"));
		from.append(createAndUsingInt("a.cargo_type:cargo_type"));
		from.append(createAnd("a.cargo_desc@like@cargo_desc"));


		if(StringUtils.isNotBlank(status)) {
			if(status.indexOf(",") == -1) {
				if(NumberUtils.toInt(status) != -1) {
					from.append(" and a.status =" + status);
				}
			}else {
				from.append(" and a.status in (" + status + ")");
			}
		}else {
			from.append(" and a.status <>-1");
		}
		from.append(" and a.status <>-1 and a.status<>0 and a.status<>1 and a.status<>3");
		if(StringUtils.isNotBlank(cargo_desc)){
			from.append(" and a.cargo_desc like '%" + cargo_desc + "%'" );
		}
		if(StringUtils.isNotBlank(plate_number)){
			from.append(" and k.plate_number like '%" + plate_number + "%'" );
		}
		if(StringUtils.isNotBlank(beginDate)){
			from.append(" and a.create_time >= '" + beginDate + "'" );
		}
		if(StringUtils.isNotBlank(endDate)){
			endDate += " 23:59:59";
			from.append(" and a.create_time <= '" + endDate + "'") ;
		}
		if(StringUtils.isNotBlank(startPoint)){
		    from.append(" and (a.start_province = " + startPoint + " or a.start_city = " + startPoint + " or a.start_district = " + startPoint + ") ");
		}
		if(StringUtils.isNotBlank(endPoint)){
            from.append(" and (a.end_province = " + endPoint + " or a.end_city = " + endPoint + " or a.end_district = " + endPoint + ") ");
        }

		from.append(" order by a.id desc");
		Page<Record> page = Db.paginate(1, 10000, select , from.toString() , getUserId() );
		Dict.fillDictToRecords(page.getList());
		System.out.println(JSONUtils.toPagedGridJSONStringUsingRecord(page));
		renderText(JSONUtils.toPagedGridJSONStringUsingRecord(page));
	}

	/**
	 * 查看进行中的订单详情
	 */
	public void showDealOrder(){
		int orderId = getParaToInt();
		Order order = getAndVerifyOrder(orderId);

		//只能查询0-已创建,1-审核通过(进行中)
		if(!order.isStauts(Order.STATUS_DEAL)) {
			throw new BusinessException("货单" + orderId + "不处于在途状态,status=" + order.getInt("status"));
		}

		int user_id = order.getInt("user_id");
		User user = User.dao.findById(user_id);
		setAttr("user", user);

		int driver_id = order.getInt("driver_id");
		Driver driver = Driver.dao.findById(driver_id);
		Dict.fillDictToModel(driver);
		//以下对司机坐标进行处理，默认为北京市中心
		if(driver == null){
			driver = new Driver();
		}
		if(driver.get("longitude") == null || driver.get("latitude") == null){
			driver.set("longitude", 116.403119);
			driver.set("latitude", 39.915156);
		}
		setAttr("driver", driver);

		Record executeRecord = Db.findFirst("select * from logistics_order_status where order_id =? order by id desc" , orderId);
		int executeStatus =  executeRecord == null ? -1 : executeRecord.getInt("status");
		setAttr("execute_status", executeStatus);

		Dict.fillDictToModel(order);
		setAttr("pwd", getUserPwd());
		setAttr("orderId", orderId);
		setAttr("order", order);
		setAttr("xmppserver", BaseConfig.me().getProperty("xmpp.server"));
		setAttr("xmppdomain", BaseConfig.me().getProperty("xmpp.domain"));
		render("showDealOrder.ftl");
	}

	/**
	 * 在途订单查询
	 */
	public void queryDealList(){

		String beginDate = getPara("beginDate");
		String endDate = getPara("endDate");
		String startPoint = getPara("start_point");
		String endPoint = getPara("end_point");
		String status = getPara("status");
		String cargo_desc = getPara("cargo_desc");
		String plate_number = getPara("plate_number");

		String select = "select a.*, k.phone as driver_phone ,k.name as driver_name ,";
		select += " k.longitude,k.latitude,k.plate_number ";

		StringBuffer from = new StringBuffer();
		from.append(" from logistics_order a ");
		from.append(" left join logistics_driver k on a.driver_id = k.id ");
		from.append(" where a.user_id=? ");
		from.append(createAndUsingInt("a.car_type:car_type"));
		from.append(createAndUsingInt("a.cargo_type:cargo_type"));
		from.append(createAnd("a.cargo_desc@like@cargo_desc"));


		if(StringUtils.isNotBlank(status)) {
			if(status.indexOf(",") == -1) {
				from.append(" and a.status =" + status);
			}else {
				from.append(" and a.status in (" + status + ")");
			}
		}else {
			from.append(" and a.status <>-1");
		}
		if(StringUtils.isNotBlank(cargo_desc)){
			from.append(" and a.cargo_desc like '%" + cargo_desc + "%'" );
		}
		if(StringUtils.isNotBlank(plate_number)){
			from.append(" and k.plate_number like '%" + plate_number + "%'" );
		}
		if(StringUtils.isNotBlank(beginDate)){
			from.append(" and a.create_time >= '" + beginDate + "'" );
		}
		if(StringUtils.isNotBlank(endDate)){
			endDate += " 23:59:59";
			from.append(" and a.create_time <= '" + endDate + "'") ;
		}
		if(StringUtils.isNotBlank(startPoint)){
		    from.append(" and (a.start_province = " + startPoint + " or a.start_city = " + startPoint + " or a.start_district = " + startPoint + ") ");
		}
		if(StringUtils.isNotBlank(endPoint)){
            from.append(" and (a.end_province = " + endPoint + " or a.end_city = " + endPoint + " or a.end_district = " + endPoint + ") ");
        }

		from.append(" order by a.id desc");
		Page<Record> page = Db.paginate(1, 10000, select , from.toString() , getUserId() );
		Dict.fillDictToRecords(page.getList());
		System.out.println(JSONUtils.toPagedGridJSONStringUsingRecord(page));
		renderText(JSONUtils.toPagedGridJSONStringUsingRecord(page));
	}

	/**
	 * 查询待定货单(已发布，未审核，或者已审核，未最终成交的)
	 */
	public void queryPendingList() {
		int user_id = getUserId();
		String select = "";
		select += "SELECT id,start_province,start_city,start_district,end_province,end_city,";
		select += "end_district,cargo_desc,cargo_type,car_length,cargo_weight,price,ship_type,";
		select += "car_type,cargo_photo1,cargo_photo2,cargo_photo3,loading_time,cargo_remark,";
		select += "validate_time,user_bond,push_drvier_count,vie_driver_count,create_time,cargo_unit,cargo_number,unit_price,";
		select += "(CASE validate_time WHEN validate_time<NOW() THEN 1 ELSE 0 END) as is_expired";

		//-1已删除,0-已创建,1-审核通过(进行中)，2-审核未通过，3-已中标，4-已取消，99-已完成
		String sqlExceptSelect = "from logistics_order where user_id=?";
//		int status = getParaToInt("status",1);
//		if(status >= 0) {
			sqlExceptSelect += " and (status= 1 or status = 0) ";
//		}
		String cargo_desc = getPara("cargo_desc");
		if(StringUtils.isNotBlank(cargo_desc)){
			sqlExceptSelect += " and cargo_desc like '%" + cargo_desc + "%'";
		}
		sqlExceptSelect += createAnd("cargo_desc@like@cargo_desc");
		sqlExceptSelect += " order by create_time desc";

		Page<Record> page = Db.paginate(getPageIndex(), getPageSize(), select, sqlExceptSelect, user_id);
		List<Record> list = page.getList();
		Dict.fillDictToRecords(list);
		renderText(JSONUtils.toPagedGridJSONStringUsingRecord(page));
	}

	public void showDriver() {
		int orderId = this.getParaToInt();
		Order order = getAndVerifyOrder(orderId);
		//只能查询0-已创建,1-审核通过(进行中)
		if(!order.isStauts(Order.STATUS_CREATED) && !order.isStauts(Order.STATUS_PASS)) {
			throw new BusinessException("货单" + orderId + "不处于待定货单状态,status=" + order.getInt("status"));
		}

		String sql = "select driver_id,plate_number,id_card,registration,license,car_photo1,car_photo2,car_photo3,car_type,car_length,((score1+score2+score3)/3) AS score";
		sql += " FROM logistics_order_vie a";
		sql += " LEFT JOIN logistics_driver b ON b.id=a.driver_id";
		sql += " WHERE a.order_id=? and a.status=0";//0-竞标中
		List<Record> driverList = Db.find(sql, orderId);
		Dict.fillDictToRecords(driverList);
	}

	private Order getAndVerifyOrder(int orderId) {
		Order order = Order.dao.findById(orderId);
		if(order == null) {
			throw new BusinessException("货单" + orderId + "不存在");
		}

		//校验订单权限
		final int currentUserId = getUserId();
		if(!order.isOwner(currentUserId)) {
			String msg = String.format("[%s]没有订单[%s]权限", UserUtil.getUserPhone(getRequest()), orderId);
			throw new BusinessException(msg);
		}

		return order;
	}

	/**
	 *
	 * @description 获取所有订单状态
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 18, 2013 10:06:13 PM
	 */
	public void showStatus(){
		try {
			renderText(JSONUtils.toJSONArray(Order.getAllStatus(), "status|text").toString());
		} catch (JSONException e) {
			log.error(e) ;
		}
	}

	/**
	 *
	 * @description 抢单记录页面
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 22, 2013 9:26:41 PM
	 */
	public void vieList(){
		setAttr("orderId", getParaToInt());
		render("order_vie.ftl");
	}

	/**
	 * 待定货单-接受订单
	 */
	@Before(Tx.class)
	public void accept_order() {
		int orderId = getParaToInt("order_id");
		int driverId = getParaToInt("driver_id");
		Order order = getAndVerifyOrder(orderId);

		//查找投标的司机信息
		OrderVie orderVie = OrderVie.dao.findFirst("select id,order_id,driver_id,driver_bond,driver_price,status from logistics_order_vie where status=0 and order_id=? and driver_id=?", orderId, driverId);
		if(orderVie == null) {
			String msg = String.format("无法找到订单[%s]对应投标记录,司机编号[%s]", orderId, driverId);
			throw new BusinessException(msg);
		}
		if(orderVie.getInt("status") == 2) {//2-退出竞标
			String msg = String.format("司机[%s]关于订单[%s]的投标已撤销,", driverId, orderId);
			throw new BusinessException(msg);
		}

		//设置为中标
		orderVie.set("status", 1);
		orderVie.update();

		//修改订单数据
		order.set("status", 3);//已中标
		order.set("driver_id", orderVie.getInt("driver_id"));
		order.set("driver_bond", orderVie.getDouble("driver_bond"));
		order.set("price", orderVie.asDouble("driver_price"));//货主端一旦确认抢单，就把order表的价格修改为司机的自报价
		order.set("deal_time", new Date());
		order.update();

		Driver acceptDriver = Driver.dao.loadDriverById(driverId);
		//查询司机其他抢单信息。退回所有抢单的保证金
		String sql = "select sum(driver_bond)   from logistics_order_vie where driver_id = ? and order_id <> ? and status = 0 ";
		Double successDriverBond = Db.queryDouble(sql , driverId  , orderId);
		if(successDriverBond == null){
			successDriverBond = (double) 0 ;
		}
		//扣司机的信息费
		final DecimalFormat format = new DecimalFormat("0.00");
		double fee = order.getFee();
		String feeStr = format.format(fee);
		//调整司机金额。 当前金额 = 原金额 +　所有保证金  - 本单信息费
		GoldResult gr1 = acceptDriver.adjustGold(successDriverBond-fee);

		//该司机中标后，退出其他所有抢单
		//调整订单抢单人数
		List<Order> otherOrders = Order.dao.find("select a.* from logistics_order a inner join logistics_order_vie b on b.order_id=a.id where b.driver_id=? and b.order_id<>? and b.status=0", driverId, orderId);
		for (Order otherOrder : otherOrders) {
			otherOrder.adjustVieCount(-1);
		}
		//该司机中标后，退出其他所有抢单
		Db.update("update logistics_order_vie set status = 2 where driver_id = ? and order_id <> ? and status = 0" , driverId , orderId);

		//更新成交订单数
		User user = User.dao.findById(getUserId());
		//modified by lpf,20130605 不需要在这里调整成交单数了。
//		user.set("order_count", user.getInt("order_count") + 1) ; //将成交订单数增加
//		user.update();

//		String returnFee = new DecimalFormat("0.00").format(fee*0.15);
//		SmsService.send(user.getStr("phone"), "感谢您对易运宝的关注与支持，编号为" + orderId + "的货单已经达成，易运宝赠送您" + returnFee + "个物流币，可用于验证、定位或购买保险。祝生意兴隆！");

		//抢单失败的司机返还保证金
		List<OrderVie> vieList = OrderVie.dao.find("select id,order_id,driver_id,driver_bond,status from logistics_order_vie where status=0 and order_id=? and driver_id<>?", orderId, driverId);
		for (OrderVie vie : vieList) {
			int failed_driver_id = vie.getInt("driver_id");
			Driver driver = Driver.dao.findById(failed_driver_id);
			double failed_driver_bond = vie.getDouble("driver_bond");
			GoldResult gr = driver.adjustGold(failed_driver_bond);
			vie.set("status", 2);
			vie.update();
			//记录帐户变化
			Business.dao.addDriverBusiness(failed_driver_id, Business.BUSINESS_TYPE_DEPOSIT_RETURN, failed_driver_bond, gr.getBeforeGold(), gr.getAfterGold());
			//发送到信息中心
			Msg.dao.addDriverMsg(Msg.TYPE_ORDER, "抢单失败", "货单号为:" + orderId + "的货物已由货主确定由" + acceptDriver.getStr("plate_number") + "的司机承运，感谢您的关注。", failed_driver_id);
			Msg.dao.addDriverMsg(Msg.TYPE_ORDER, "保证金返还", "货单号为:" + orderId + "的货物已由其他司机与发货方达成交易，现返还您保证金：" + failed_driver_bond, failed_driver_id);
		}





		//发送手机短信
		String msg = "货主选择您承运号：" + orderId + "的货物，本次交易扣除信息费" + feeStr + "，请您及时与发货方联系，并签订运输合同。本次交易退还所有保证金，并扣除信息费后，总计返还：" + gr1.getAmount();
		SmsService.send(acceptDriver.getStr("phone"), msg);
		//记录帐户变化
		Business.dao.addDriverBusiness(driverId, Business.BUSINESS_TYPE_DEAL, gr1.getAmount(), gr1.getBeforeGold(), gr1.getAfterGold());
		//发送到信息中心
		Msg.dao.addDriverMsg(Msg.TYPE_ORDER, "交易成功", msg, driverId);

		//通知到货主的消息中心
		String userMsg = "您发布的货单：" + orderId + "的货单交易达成，抢单司机：" + acceptDriver.getStr("name");
		Msg.dao.addUserMsg(Msg.TYPE_ORDER, "交易成功", userMsg, getUserId());
		//给货主发送手机短信
		SmsService.send(user.getStr("phone"), userMsg);

		//2013-06-05 23:27:36 不要了，在回单密码验证成功，交易完成之后才返回奖励
//		//奖励货主
//		double award = fee * 0.15;//按信息费的15%奖励给发货方
//		user.adjustGold(award);
//
//		//给货主发送信息
//		String userMsg = "您发布的货单：" + orderId + "的货单交易达成，获得易运宝奖励信息费" + format.format(award);
//		Msg.dao.addUserMsg(Msg.TYPE_ORDER, "交易成功", userMsg, getUserId());
//		//发送手机短信
//		SmsService.send(user.getStr("phone"), userMsg);
//		//记录帐户变化
//		Business.dao.addUserBusiness(getUserId(), Business.BUSINESS_TYPE_AWARD, award, 0, 0);

		//记录订单变更
		OrderLog.logOrder(orderId, "货主[" + user.getStr("name") + "]", "接受抢单,司机姓名:" + acceptDriver.getStr("name"));
		renderJson(JSONUtils.toMsgJSONString("成功", true));
	}

	/**
	 * 取消货单
	 */
	@Before(Tx.class)
	public void cancel_order() {
		int orderId = getParaToInt("order_id");

		Order order = getAndVerifyOrder(orderId);
		final double user_bond = order.getDouble("user_bond");

		//尚未审核的货单直接取消
		if(order.isStauts(Order.STATUS_CREATED)) {
			//取消订单
			order.set("status", Order.STATUS_CANCEL);
			order.update();

			User user = User.dao.loadUserById(getUserId());
			GoldResult gr = user.adjustGold(user_bond);//返还保证金

			Business.dao.addUserBusiness(getUserId(), Business.BUSINESS_TYPE_DEPOSIT_RETURN, user_bond, gr.getBeforeGold(), gr.getAfterGold());
			Msg.dao.addUserMsg(Msg.TYPE_ORDER, "货单取消", "货单已经取消，货单号：" + orderId, getUserId());

			//记录订单变更
			OrderLog.logOrder(orderId, "货主[" + user.getStr("name") + "]", "取消了货单");
			renderJson(JSONUtils.toMsgJSONString("成功", true));
			return;
		}

		if(!order.isStauts(Order.STATUS_PASS)) {
			throw new BusinessException("货单" + orderId + "不在待定状态，无法取消.");
		}

		//获取抢单司机
		List<OrderVie> vieList = OrderVie.dao.getActiveVieListByOrder(orderId);

		if(vieList.isEmpty()) {//没有抢单，直接取消订单
			//取消订单
			order.set("status", Order.STATUS_CANCEL);
			order.update();

			User user = User.dao.loadUserById(getUserId());
			GoldResult gr = user.adjustGold(user_bond);//解冻保证金
			//记录信息
			Business.dao.addUserBusiness(getUserId(), Business.BUSINESS_TYPE_DEPOSIT_RETURN, user_bond, gr.getBeforeGold(), gr.getAfterGold());
			Msg.dao.addUserMsg(Msg.TYPE_ORDER, "货单取消", "货单已经取消，货单号：" + orderId, getUserId());
		}else {
			if(user_bond <= 0) {//如果有抢单，且保证金为0，那么无法取消.
				throw new BusinessException("取消订单将严重影响你的信誉。若有特殊情况，请联系客服取消");
			}else {//赔付给司机
				int vieCount = vieList.size();
				final double paid = user_bond / vieCount;//每位司机赔付的金额
				for (OrderVie orderVie : vieList) {
					//将货主的赔付金额付给司机
					int driver_id = orderVie.getInt("driver_id");
					Driver driver = Driver.dao.loadDriverById(driver_id);
					GoldResult gr1 = driver.adjustGold(paid);
					//记录帐户变化并发送信息
					Business.dao.addDriverBusiness(driver_id, Business.BUSINESS_TYPE_VIOLATE_PAID, paid, gr1.getBeforeGold(), gr1.getAfterGold());
					Msg.dao.addDriverMsg(Msg.TYPE_BUSINIESS, "保证金赔偿", "货主违约，赔偿保证金:" + paid + ",货单号：" + orderId, driver_id);

					//返回司机保证金
					final double driver_bond = orderVie.asDoubleValue("driver_bond", 0);
					GoldResult gr2 = driver.adjustGold(driver_bond);

					//记录帐户变化并发送信息
					Business.dao.addDriverBusiness(driver_id, Business.BUSINESS_TYPE_VIOLATE_RETURN, driver_bond, gr2.getBeforeGold(), gr2.getAfterGold());
					Msg.dao.addDriverMsg(Msg.TYPE_BUSINIESS, "保证金返还", "货主违约，返还保证金:" + driver_bond + ",货单号：" + orderId, driver_id);

					Msg.dao.addDriverMsg(Msg.TYPE_ORDER, "货单取消", "货单已经取消，货单号：" + orderId, driver_id);
				}
				//取消订单
				order.set("status", Order.STATUS_CANCEL);
				order.update();

				Msg.dao.addUserMsg(Msg.TYPE_ORDER, "货单取消", "货单已经取消，所缴纳的保证金：" + user_bond + "已赔付给抢单的司机，货单号：" + orderId, getUserId());
			}
		}

		//记录订单变更
		User user = User.dao.loadUserById(getUserId());
		OrderLog.logOrder(orderId, "货主[" + user.getStr("name") + "]", "取消了货单");

		renderJson(JSONUtils.toMsgJSONString("成功", true));
	}

	/**
	 * 待定货单详情
	 */
	public void showPendingOrderDetail() {
		setAttr("orderId", getParaToInt());
		int orderId = getParaToInt();
		Order order = getAndVerifyOrder(orderId);

		//只能查询0-已创建,1-审核通过(进行中)
		if(!order.isStauts(Order.STATUS_CREATED) && !order.isStauts(Order.STATUS_PASS)) {
			throw new BusinessException("货单" + orderId + "不处于待定货单状态,status=" + order.getInt("status"));
		}

		Dict.fillDictToModel(order);
		setAttr("order", order);
		render("showPendingOrderDetail.ftl");
	}

	/**
	 * 历史货单详情
	 */
	public void showHistoryOrderDetail() {
		int orderId = getParaToInt();

		//订单信息
		Order order = getAndVerifyOrder(orderId);
		Dict.fillDictToModel(order);
		setAttr("orderId", orderId);
		setAttr("order", order);

		//货主信息
		int user_id = order.getInt("user_id");
		User user = User.dao.loadUserById(user_id);
		setAttr("user", user);

		//司机信息
		Integer driver_id = order.getInt("driver_id");
		if(driver_id != null && driver_id != 0) {
			Driver driver = Driver.dao.loadDriverById(driver_id);
			Dict.fillDictToModel(driver);
			//以下对司机坐标进行处理，默认为北京市中心
			if(driver == null){
				driver = new Driver();
			}
			if(driver.get("longitude") == null || driver.get("latitude") == null){
				driver.set("longitude", 116.403119);
				driver.set("latitude", 39.915156);
			}
			setAttr("driver", driver);
		}

		render("showHistoryOrderDetail.ftl");
	}

	/**
	 * 货主评价司机-显示评价界面
	 * @param param
	 * @return
	 */
	public void rating_to_driver() {
		int order_id = getParaToInt();
		Order order = Order.dao.findById(order_id);
		Dict.fillDictToModel(order);
		setAttr("order_id", order_id);
		setAttr("order", order);
		render("rating_to_driver.ftl");
	}

	/**
	 * 货主评价司机
	 * @param param
	 * @return
	 */
	public void do_rating_to_driver() {
		int order_id = getParaToInt("order_id");
		String reply_content = getPara("reply_content");
		int score1 = getParaToInt("score1");
		int score2 = getParaToInt("score2");
		int score3 = getParaToInt("score3");

		//获取订单信息
		Order order = getAndVerifyOrder(order_id);

		if(!order.isStauts(Order.STATUS_FINISH)) {
			throw new BusinessException("只能评价已完成的订单.");
		}

		if(order.getInt("driver_reply") == 1) {
			throw new BusinessException("已对订单进行了评价.");
		}

		int driverId = order.getInt("driver_id");
		DriverReply reply = new DriverReply();
		reply.set("driver_id", driverId);
		reply.set("score1", score1);
		reply.set("score2", score2);
		reply.set("score3", score3);
		reply.set("reply_content", reply_content);
		reply.set("order_id", order_id);
		reply.set("reply_time", new Date());
		reply.save();

		//更新评价情况
		order.set("driver_reply", 1);
		order.update();

		//给司机推送消息
		Msg.dao.addDriverMsg(Msg.TYPE_ORDER, "货单已评价", "货单:" + order_id + "已评价", driverId);

		//记录订单变更
		User user = User.dao.loadUserById(getUserId());
		OrderLog.logOrder(order_id, "货主[" + user.getStr("name") + "]", "对司机进行评价.");

		renderText("{\"success\": true}");
	}

	/**
	 * 调整订单价格
	 */
	public void adjustPrice() {
		int orderId = getParaToInt("order_id");
		double unit_price = Double.valueOf(getPara("unit_price"));

		Order order = getAndVerifyOrder(orderId);

		//只能查询0-已创建,1-审核通过(进行中)
		if(!order.isStauts(Order.STATUS_CREATED) && !order.isStauts(Order.STATUS_PASS)) {
			throw new BusinessException("货单" + orderId + "不处于待定货单状态,status=" + order.getInt("status"));
		}

		//判断是否有人抢单
		if(OrderVie.dao.hasVieByOrderId(orderId)) {
			throw new BusinessException("货单" + orderId + "已有人抢单,不能调整价格");
		}

		int cargo_number = order.getInt("cargo_number");

		double price = cargo_number * unit_price;

		//更新订单价格
		order.set("unit_price", unit_price);
		order.set("price", price);
		order.set("status", Order.STATUS_CREATED);//调整价格之后,需要重新审核
		order.update();

		User user = User.dao.findById(getUserId());

		//发送消息
		Msg.dao.addUserMsg(Msg.TYPE_ORDER, "货单状态变更", "货单已调整价格，需重新待系统审核，货单号：" + orderId, getUserId());

		//记录订单变更
		OrderLog.logOrder(orderId, "货主[" + user.getStr("name") + "]", "调整了货单价格为:" + price + "，货单等待重新审核.");

		renderJson(JSONUtils.toMsgJSONString("成功", true));
	}

	/**
	 *
	 * @description 获取抢单记录
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 22, 2013 9:17:37 PM
	 */
	public void queryVie(){
		int orderId = getParaToInt();
		String select = "select a.*,b.name as driver_name , b.phone, b.plate_number " ;
		String from = " from logistics_order_vie a left join logistics_driver  b on a.driver_id = b.id where  a.order_id = " + orderId + " order by a.driver_price desc, a.id desc" ;
		Page<Record> page = Db.paginate(getPageIndex(), getPageSize(),
				select , from );
		renderText(JSONUtils.toPagedGridJSONStringUsingRecord(page));
	}

	public void show_vie_driver() {
		int driver_id = getParaToInt(0);
		int orderId = getParaToInt(1);
		Driver driver = Driver.dao.findById(driver_id);
		Dict.fillDictToModel(driver);
		setAttr("orderId", orderId);
		setAttr("driver", driver);
		render("show_vie_driver.ftl");
	}

	/**
	 *
	 * @description 货物状态页面
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 24, 2013 10:25:25 PM
	 */
	public void statusList(){
		setAttr("orderId", getParaToInt());
		render("order_status.ftl");
	}

	/**
	 *
	 * @description 查询货物状态
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 24, 2013 10:29:02 PM
	 */
	public void queryStatus(){
		int orderId = getParaToInt();
		String select = "select * " ;
		String from = " from logistics_order_status where order_id = " + orderId + " order by id desc" ;
		Page<Record> page = Db.paginate(getPageIndex(), getPageSize(),
				select , from );
		renderText(JSONUtils.toPagedGridJSONStringUsingRecord(page));
	}

	/**
	 *
	 * @description 司机位置历史记录页面
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 24, 2013 10:39:59 PM
	 */
	public void locationList(){
		setAttr("orderId", getParaToInt());
		render("order_location.ftl");
	}

	/**
	 *
	 * @description
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 24, 2013 10:40:26 PM
	 */
	public void queryLocation(){
		int orderId = getParaToInt();
		String select = "select * " ;
		String from = " from logistics_order_location where order_id = " + orderId + " order by id desc" ;
		Page<Record> page = Db.paginate(getPageIndex(), getPageSize(),
				select , from );
		renderText(JSONUtils.toPagedGridJSONStringUsingRecord(page));
	}

	/**
	 *
	 * @description 货主订单列表 页面
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 31, 2013 5:52:33 PM
	 */
	public void userOrder(){
		setAttr("userId", getParaToInt()) ;
		render("user_order.ftl");
	}

	/**
	 *
	 * @description 货主订单列表
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 31, 2013 5:52:43 PM
	 */
	public void queryUserOrder(){
		int userId = getParaToInt();
		String select = "select a.* , b.name as cargo_type_name , c.name as car_type_name ,d.name as start_province_name , " +
				"e.name as start_city_name , f.name as start_district_name,g.name as end_province_name , h.name as end_city_name , " +
				"i.name as end_district_name ,j.name as disburden_type_name ,k.phone as driver_phone ,k.name as driver_name ," +
				"m.phone as user_phone, m.name as user_name";
		StringBuffer from = new StringBuffer();
		from.append(" from logistics_order a ");
		from.append(" left join logistics_dict b on a.cargo_type = b.id ");
		from.append(" left join logistics_dict c on a.car_type = c.id");
		from.append(" left join logistics_area d on a.start_province = d.id ");
		from.append(" left join logistics_area e on a.start_city = e.id ");
		from.append(" left join logistics_area f on a.start_district = f.id");
		from.append(" left join logistics_area g on a.end_province = g.id ");
		from.append(" left join logistics_area h on a.end_city = h.id ");
		from.append(" left join logistics_area i on a.end_district = i.id");
		from.append(" left join logistics_dict j on a.disburden_type = j.id ");
		from.append(" left join logistics_driver k on a.driver_id = k.id ");
		from.append(" left join logistics_user m on a.user_id = m.id ");
		from.append(" where a.status!=-1 and user_id= " + userId);
		from.append(" order by a.id desc");

		Page<Record> page = Db.paginate(getPageIndex(), getPageSize(),
				select , from.toString() );
		renderText(JSONUtils.toPagedGridJSONStringUsingRecord(page));
	}

	/**
	 *
	 * @description 司机订单列表，页面
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 1, 2013 7:52:32 PM
	 */
	public void driverOrder(){
		setAttr("driverId", getParaToInt()) ;
		render("driver_order.ftl");
	}

	/**
	 *
	 * @description 司机订单列表
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 1, 2013 7:49:40 PM
	 */
	public void queryDriverOrder(){
		int driverId = getParaToInt();
		String select = "select a.* , b.name as cargo_type_name , c.name as car_type_name ,d.name as start_province_name , " +
				"e.name as start_city_name , f.name as start_district_name,g.name as end_province_name , h.name as end_city_name , " +
				"i.name as end_district_name ,j.name as disburden_type_name ,k.phone as driver_phone ,k.name as driver_name ," +
				"m.phone as user_phone, m.name as user_name , n.status as vie_status ";
		StringBuffer from = new StringBuffer();
		from.append(" from logistics_order a ");
		from.append(" left join logistics_dict b on a.cargo_type = b.id ");
		from.append(" left join logistics_dict c on a.car_type = c.id");
		from.append(" left join logistics_area d on a.start_province = d.id ");
		from.append(" left join logistics_area e on a.start_city = e.id ");
		from.append(" left join logistics_area f on a.start_district = f.id");
		from.append(" left join logistics_area g on a.end_province = g.id ");
		from.append(" left join logistics_area h on a.end_city = h.id ");
		from.append(" left join logistics_area i on a.end_district = i.id");
		from.append(" left join logistics_dict j on a.disburden_type = j.id ");
		from.append(" left join logistics_driver k on a.driver_id = k.id ");
		from.append(" left join logistics_user m on a.user_id = m.id ");
		from.append(" left join logistics_order_vie n on a.id = n.order_id ");
		from.append(" where a.status!=-1 and n.driver_id = " + driverId);
		from.append(" order by a.id desc");

		Page<Record> page = Db.paginate(getPageIndex(), getPageSize(),
				select , from.toString() );
		renderText(JSONUtils.toPagedGridJSONStringUsingRecord(page));
	}

	/**
	 *
	 * @description 查看在途货源地图
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 4, 2013 9:54:50 PM
	 */
	public void showMap(){
		int userId = getUserId();
		StringBuffer sql = new StringBuffer();
		sql.append(" select a.*, k.phone as driver_phone ,k.name as driver_name ,k.longitude,k.latitude,k.plate_number ");
		sql.append(" from logistics_order a ");
		sql.append(" left join logistics_driver k on a.driver_id = k.id ");
		sql.append(" where a.user_id = ? and  a.status = ?  and k.longitude is not null and k.latitude is not null");
		List<Record> list = Db.find(sql.toString(),   userId ,Order.STATUS_DEAL ) ;
		setAttr("orders", list);
		for(Record r : list){
			log.info(" orders:" + r);

		}
		render("map.ftl");
	}

	/**
	 *
	 * @description 回单密码
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 29, 2013 12:22:27 AM
	 */
	public void receipt(){
		int orderId = getParaToInt("id");
		String receipt_password = getPara("receipt_password");
		Order order = getAndVerifyOrder(orderId);
		order.set("receipt_password", receipt_password);
		order.update();
		Msg.dao.addUserMsg(Msg.TYPE_ORDER, "货单回单密码", "货单已创建回单密码：" + receipt_password + "，请记住该密码并发送给收货方，货单号：" + orderId, getUserId());
		render("receipt_ok.ftl");
	}
	
	/**
	 * 
	 * @description 轨迹回放
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * 2013年7月15日 下午8:59:39
	 */
	public void trajectory(){
		int orderId = getParaToInt("id");
		Order order = Order.dao.findById(orderId);
		if(order.getInt("user_id") != getUserId()){
			throw new RuntimeException("非法数据请求");
		}
		String sql = "select * from logistics_order_location where order_id = ? order by id" ;
		List<Record> list = Db.find(sql , orderId);
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
		render("trajectory.ftl");
	}
	
	public void weixinPublishOrder(){
		render("sendOutGood.html");
	}
	

	@Before(Tx.class)
	public void weixinDoPublishOrder() {
		
		String start_province = getPara("start_province_id");
		String start_city = getPara("start_city_id");
		String end_province = getPara("end_province_id");
		String end_city = getPara("end_city_id");
		//货物名称
		String cargo_desc = getPara("cargo_desc");
		//联系人及联系电话
		String cargo_user_name = getPara("cargo_user_name");
		String cargo_user_phone = getPara("cargo_user_phone");
		//货物类型
		String cargo_type = getPara("cargo_type");
		if(null != cargo_type && !"0".equals(cargo_type.trim())){			
			Dict.verifyDict("cargo_type", Integer.parseInt(cargo_type));
		}
		//车长
		double car_length = NumberUtils.toDouble(getPara("car_length") , 0) ;
		//货物数量+重量
		String cargo_number_str = getPara("cargo_number");//货物数量
		String cargo_unit_str = getPara("cargo_unit");//货物数量单位
		int cargo_number_int = 0;
		int cargo_unit_int = 0;
		if(null != cargo_number_str && !"".equals(cargo_number_str.trim())){
			cargo_number_int = Integer.parseInt(cargo_number_str);
		}
		if(null != cargo_unit_str && !"".equals(cargo_unit_str.trim())){
			cargo_unit_int = Integer.parseInt(cargo_unit_str);
		}
		//价格
		Double unit_price = NumberUtils.toDouble(getPara("unit_price") , 0);//货物单价
		Double price = unit_price * cargo_number_int;//总价
		//运输方式
		String ship_type = getPara("ship_type");
		if(null != ship_type && !"0".equals(ship_type.trim())){			
			Dict.verifyDict("ship_type", Integer.parseInt(ship_type));
		}
		//车辆类型
		String car_type = getPara("car_type");
		if(null != car_type && !"0".equals(car_type.trim())){			
			Dict.verifyDict("car_type", Integer.parseInt(car_type));
		}

		Date loading_time = TimeUtil.parse(getPara("loading_time"), "yyyy-MM-dd HH:mm:ss", null);
		String cargo_remark = getPara("cargo_remark");
		Date validate_time = null;
		if(getPara("validate_time") != null && !"0".equals(getPara("validate_time"))){
			validate_time = new Date(getParaToLong("validate_time"));
		}

		Double user_bond = Double.valueOf(getPara("user_bond","0.0"));


		//校验保证金
		/*User user = User.dao.findById(getUserId());
		Double gold = user.getDouble("gold");
		if(gold == null || (gold < user_bond)) {
			renderHtml("余额" + gold + "不足以支付保证金与信息费,共计<b>" + user_bond + "</b>请先<a href=\"/pay\" target=\"_blank\">充值</a>");
			return;
		}*/

		Order order = new Order();
		order.set("user_id", getUserId());
		order.set("start_province", start_province);
		if(null != start_city && !"".equals(start_city)){			
			order.set("start_city", start_city);
		}
		order.set("end_province", end_province);
		if(null != end_city && !"".equals(end_city)){			
			order.set("end_city", end_city);
		}
		order.set("cargo_desc", cargo_desc);
		if(null != cargo_type && !"".equals(cargo_type.trim())){			
			order.set("cargo_type", cargo_type);
		}
		order.set("car_length", car_length);
		order.set("cargo_number", cargo_number_int);
		order.set("cargo_unit", cargo_unit_int);
		if(null != cargo_user_name && !"".equals(cargo_user_name)){
			order.set("cargo_user_name", cargo_user_name);
		}
		if(null != cargo_user_phone && !"".equals(cargo_user_phone)){
			order.set("cargo_user_phone", cargo_user_phone);
		}
		order.set("unit_price", unit_price);
		order.set("price", price);
		if(null != ship_type && !"".equals(ship_type.trim())){			
			order.set("ship_type", ship_type);
		}
		if(null != car_type && !"".equals(car_type.trim())){			
			order.set("car_type", car_type);
		}
		/*if(getPara("cargo_photo1") != null) {
			UploadFile uf = getFile("cargo_photo1");
			FileInfo fileInfo = ImageService.saveFile(uf.getFileName(), uf.getFile());
			String cargo_photo1 = fileInfo.getVirtualUrl();
			order.set("cargo_photo1", cargo_photo1);
		}*/
		order.set("loading_time", loading_time);
		order.set("cargo_remark", cargo_remark);
		order.set("validate_time", validate_time);//有效日期为当前时间+有效时间数量
		order.set("user_bond", user_bond);
		order.set("create_time", new Date());
		order.set("push_drvier_count", 0); //推送给相关司机数量（需等审核通过后才能推送）
		order.save();

		//扣除保证金
		//GoldResult gr = user.adjustGold(-user_bond);
		
		//扣除后给货主发送信息
		//Business.dao.addUserBusiness(getUserId(), Business.BUSINESS_TYPE_DEPOSIT, user_bond, gr.getBeforeGold(), gr.getAfterGold());
		//Msg.dao.addUserMsg(Msg.TYPE_BUSINIESS, "保证金扣除", "发布货源，扣除保证金:" + user_bond, getUserId());

		//记录订单信息
		//OrderLog.logOrder(order.getInt("id"), "货主[" + user.getStr("name") + "]", "发布订单.");

		//跳转到设置回单密码界面
		//setAttr("order", order);
		renderJson(JSONUtils.toJson("成功", true));
	}
	public void success(){
		render("sendOutGood_success.html");
	}
}
