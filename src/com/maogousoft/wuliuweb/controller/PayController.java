/**
 * @filename PayController.java
 */
package com.maogousoft.wuliuweb.controller;

import java.io.UnsupportedEncodingException;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.Assert;

import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.maogousoft.wuliuweb.common.BaseController;
import com.maogousoft.wuliuweb.common.utils.JSONUtils;
import com.maogousoft.wuliuweb.domain.Business;
import com.maogousoft.wuliuweb.domain.Coupon;
import com.maogousoft.wuliuweb.domain.Driver;
import com.maogousoft.wuliuweb.domain.GoldResult;
import com.maogousoft.wuliuweb.domain.Msg;
import com.maogousoft.wuliuweb.domain.Pay;
import com.maogousoft.wuliuweb.domain.User;
import com.maogousoft.wuliuweb.pay.alipay.AlipayConfig;
import com.maogousoft.wuliuweb.pay.alipay.AlipayNotify;
import com.maogousoft.wuliuweb.pay.alipay.AlipaySubmit;
import com.maogousoft.wuliuweb.pay.yibao.Configuration;
import com.maogousoft.wuliuweb.pay.yibao.PaymentForOnlineService;

/**
 * @description 支付
 * @author shevliu
 * @email shevliu@gmail.com May 18, 2013 2:25:40 PM
 */
public class PayController extends BaseController {

	private static final Log log = LogFactory.getLog(PayController.class);

	public void index() {
		User user = User.dao.findById(getUserId());
		setAttr("user", user);
		render("pay.ftl");
	}

	public void pay() {
		int pay_platform = getParaToInt("pay_platform", 1); // 默认易宝
		int userId = getUserId() ;
		User user = User.dao.findById(userId);
		String u_id = "u" + userId;
		if(pay_platform == 3){
			//易运宝支付，直接输入卡号密码
			String card_no = getPara("card_no");
			String card_pwd = getPara("card_pwd");
			Coupon coupon = Coupon.dao.findFirst("select * from logistics_coupon where card_no=? ", card_no);
			if(coupon == null){
				setAttr("success", false);
				setAttr("msg", "充值卡号不正确");
				render("coupon_fail.ftl");
				return;
			}
			if(!coupon.getStr("card_pwd").equals(card_pwd)){
				setAttr("success", false);
				setAttr("msg", "充值卡密码不正确");
				render("coupon_fail.ftl");
				return;
			}
			if(coupon.getInt("status") == Coupon.STATUS_USED){
				setAttr("success", false);
				setAttr("msg", "充值卡已被消费过，不能再次使用");
				render("coupon_fail.ftl");
				return;
			}
			GoldResult goldResult = user.adjustGold(100);
			coupon.set("uid", u_id);
			coupon.set("status", Coupon.STATUS_USED);
			coupon.set("use_time", new Date());
			coupon.update();
			Business.dao.addUserBusiness(userId, Business.BUSINESS_TYPE_RECHARGE, 100, goldResult.getBeforeGold(), goldResult.getAfterGold());
			Msg.dao.addUserMsg(Msg.TYPE_BUSINIESS, "充值成功", "通过易运宝充值卡充值100元", userId);
			setAttr("success", true);
			setAttr("user", user);
			render("coupon_ok.ftl");
			return;
		}
		double pay_money = NumberUtils.toDouble(getPara("pay_money"), -1);
		if(pay_money == -1){
			//此处处理用户自定义金额
			pay_money = NumberUtils.toDouble(getPara("pay_money2"), 0);
		}
		System.out.println("pay_money------->" + pay_money);
		Assert.isTrue(pay_money > 0, "支付金额必须大于0");
		Pay pay = new Pay();
		pay.set("u_id", u_id);
		pay.set("u_phone", user.getStr("phone"));
		pay.set("u_name", user.getStr("company_name"));
		pay.set("pay_money", pay_money);
		pay.set("pay_platform", pay_platform);
		// TODO channel未实现
		pay.set("pay_channel", "");
		pay.set("status", Pay.STATUS_CREATE);
		pay.set("create_time", new Date());
		pay.save();
		
		if(pay_platform == 1) {
			redirect("/pay/yibaoConfirm/" + pay.getInt("id"));
		} else {
			redirect("/pay/alipayConfirm/" + pay.getInt("id"));
		}
	}

	/**
	 * 
	 * @description 二次确认-易宝
	 * @author shevliu
	 * @email shevliu@gmail.com May 19, 2013 6:44:51 PM
	 */
	public void yibaoConfirm() {
		try {
			Pay pay = Pay.dao.findById(getParaToInt());
			String u_id = pay.getStr("u_id");
			if (pay != null && u_id.substring(1).equals(getUserId() + "")) {
				//保留2位小数
				DecimalFormat df = new DecimalFormat("0.00");
				String pay_money = df.format(pay.getDouble("pay_money"));
				String p5_Pid =  pay_money + "RMB";
				// 构造易宝支付token
				String hmac = PaymentForOnlineService
						.getReqMd5HmacForOnlinePayment("Buy", Configuration
								.getInstance().getValue("p1_MerId"), pay
								.getInt("id")
								+ "", pay_money + "", "CNY",
								p5_Pid , "", "",
								"http://www.1yunbao.com/pay/yibao", "0", "",
								"", "1", Configuration.getInstance().getValue(
										"keyValue"));
				log.debug("hmac:" + hmac);
				// 商户编号
				setAttr("p1_MerId", Configuration.getInstance().getValue("p1_MerId"));
				setAttr("p5_Pid", p5_Pid);
				setAttr("hmac", hmac);
				setAttr("pay", pay);
				setAttr("payUrl", Configuration.getInstance().getValue("yeepayCommonReqURL"));
				render("yibao_confirm.ftl");
			} else {
				renderHtml("没有权限");
			}
		} catch (RuntimeException re) {
			log.error("确认订单失败", re);
			renderHtml("确认订单失败，请重试");
		}
	}

	/**
	 * 
	 * @description 易宝支付回调接口 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 19, 2013 8:47:44 PM
	 */
	@Before(Tx.class)
	public void yibao() {
		log.info("===========易宝回调");
		String keyValue   = Configuration.getInstance().getValue("keyValue");   // 商家密钥
		String r0_Cmd 	  = getPara("r0_Cmd"); // 业务类型
		String p1_MerId   = Configuration.getInstance().getValue("p1_MerId");   // 商户编号
		String r1_Code    = getPara("r1_Code");// 支付结果
		String r2_TrxId   = getPara("r2_TrxId");// 易宝支付交易流水号
		String r3_Amt     = getPara("r3_Amt");// 支付金额
		String r4_Cur     = getPara("r4_Cur");// 交易币种
		String r5_Pid = "";
		try {
			r5_Pid = new String(getPara("r5_Pid").getBytes("iso-8859-1"),"gbk");
		} catch (UnsupportedEncodingException e) {
			log.error(e);
		}// 商品名称
		String r6_Order   = getPara("r6_Order");// 商户订单号
		String r7_Uid     = getPara("r7_Uid");// 易宝支付会员ID
		String r8_MP = "";
		try {
			r8_MP = new String(getPara("r8_MP").getBytes("iso-8859-1"),"gbk");
		} catch (UnsupportedEncodingException e) {
			log.error(e);
		}// 商户扩展信息
		String r9_BType   = getPara("r9_BType");// 交易结果返回类型
		String hmac       = getPara("hmac");// 签名数据
		boolean isOK = false;
		// 校验返回数据包
		isOK = PaymentForOnlineService.verifyCallback(hmac,p1_MerId,r0_Cmd,r1_Code, 
				r2_TrxId,r3_Amt,r4_Cur,r5_Pid,r6_Order,r7_Uid,r8_MP,r9_BType,keyValue);
		double recharge = NumberUtils.toDouble(r3_Amt);
		if(isOK) {
			//在接收到支付结果通知后，判断是否进行过业务逻辑处理，不要重复进行业务逻辑处理
			if(r1_Code.equals("1")) {
				
				//注意这里，用到了forupdate进行锁定，避免重复执行
				Pay pay = Pay.dao.findFirst("select * from logistics_pay where id = ? for update" , NumberUtils.toInt(r6_Order)) ;
				
				if(pay.getInt("status") == Pay.STATUS_CREATE){
					//当回调状态为成功时，更新支付表状态，并给用户充值
					pay.set("status", Pay.STATUS_SUCCESS);
					pay.set("finish_time", new Date());
					pay.set("platform_order", r2_TrxId);
					pay.update();
					
					String u_id = pay.getStr("u_id");
					//货主充值
					if(u_id.startsWith("u")){
						int userId = NumberUtils.toInt(StringUtils.substringAfter(u_id, "u")) ;
						User user = User.dao.findById(userId);
						double beforeMoney = user.get("gold") == null ? 0 : user.getDouble("gold");
						double afterMoney = beforeMoney + recharge ;
						Db.update("update logistics_user set gold = ? where id = ?" , afterMoney ,userId );
						String businessSql = "insert into logistics_business (business_target , account , business_type , business_amount , before_balance , after_balance , create_time , system_user_id) values (?,?,?,?,?,?,?,?)" ;
						Db.update(businessSql , Business.TARGET_TYPE_USER , userId , Business.BUSINESS_TYPE_RECHARGE , recharge , beforeMoney , afterMoney , new Date(),null);
						Msg.dao.addUserMsg(Msg.TYPE_BUSINIESS, "充值成功", "易宝支付成功，充值金额:" + recharge, userId);
					}
					//司机充值
					else if(u_id.startsWith("d")){
						int driverId = NumberUtils.toInt(StringUtils.substringAfter(u_id, "u")) ;
						Driver driver = Driver.dao.findById(driverId);
						double beforeMoney = driver.getDouble("gold");
						double afterMoney = beforeMoney + recharge ;
						Db.update("update logistics_driver set gold = ? where id = ?" , afterMoney ,driverId );
						String businessSql = "insert into logistics_business (business_target , account , business_type , business_amount , before_balance , after_balance , create_time , system_user_id) values (?,?,?,?,?,?,?,?)" ;
						Db.update(businessSql , Business.TARGET_TYPE_DRIVER , driverId , Business.BUSINESS_TYPE_RECHARGE , recharge , beforeMoney , afterMoney , new Date(),null);
						Msg.dao.addDriverMsg(Msg.TYPE_BUSINIESS, "充值成功", "易宝支付成功，充值金额:" + recharge, driverId);
					}
					
				}
				// 产品通用接口支付成功返回-浏览器重定向
				if(r9_BType.equals("1")) {
					setAttr("pay", pay);
					render("pay_ok.ftl");
					// 产品通用接口支付成功返回-服务器点对点通讯
				} else if(r9_BType.equals("2")) {
					// 如果在发起交易请求时	设置使用应答机制时，必须应答以"success"开头的字符串，大小写不敏感
					renderHtml("SUCCESS");
				}
			}
		} else {
			renderHtml("交易签名被篡改!");
		}
		
		
	}

	/**
	 * 
	 * @description 支付宝二次确认 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 25, 2013 12:42:54 AM
	 */
	public void alipayConfirm(){
		HttpServletRequest request = getRequest() ;
		try {
			Pay pay = Pay.dao.findById(getParaToInt());
			String u_id = pay.getStr("u_id");
			if (pay != null && u_id.substring(1).equals(getUserId() + "")) {
				
				DecimalFormat df = new DecimalFormat("0.00");
				String pay_money = df.format(pay.getDouble("pay_money"));
				
				//支付类型
				String payment_type = "1";
				//必填，不能修改
				//服务器异步通知页面路径
				String notify_url = "http://www.1yunbao.com/pay/alipayCallBack";
				//需http://格式的完整路径，不能加?id=123这类自定义参数

				//页面跳转同步通知页面路径
				String return_url = "http://www.1yunbao.com/pay/alipay";
				//需http://格式的完整路径，不能加?id=123这类自定义参数，不能写成http://localhost/

				//卖家支付宝帐户
				String seller_email = "18081089935";
				//必填

				//商户订单号
				String out_trade_no = pay.getInt("id") + "";
				//商户网站订单系统中唯一订单号，必填

				//订单名称
				String subject = "物流币"+pay_money+"元";
				//必填

				//付款金额
				String price = pay_money;
				//必填

				//商品数量
				String quantity = "1";
				//必填，建议默认为1，不改变值，把一次交易看成是一次下订单而非购买一件商品
				//物流费用
				String logistics_fee = "0.00";
				//必填，即运费
				//物流类型
				String logistics_type = "EXPRESS";
				//必填，三个值可选：EXPRESS（快递）、POST（平邮）、EMS（EMS）
				//物流支付方式
				String logistics_payment = "SELLER_PAY";
				//必填，两个值可选：SELLER_PAY（卖家承担运费）、BUYER_PAY（买家承担运费）
				//订单描述

				String body = "";
				//商品展示地址
				String show_url = "";
				//需以http://开头的完整路径，如：http://www.xxx.com/myorder.html

				//收货人姓名
				String receive_name = "";
				//如：张三

				//收货人地址
				String receive_address = "";
				//如：XX省XXX市XXX区XXX路XXX小区XXX栋XXX单元XXX号

				//收货人邮编
				String receive_zip = "";
				//如：123456

				//收货人电话号码
				String receive_phone = "";
				//如：0571-88158090

				//收货人手机号码
				String receive_mobile = "";
				//如：13312341234
				
				
				//////////////////////////////////////////////////////////////////////////////////
				
				//把请求参数打包成数组
				Map<String, String> sParaTemp = new HashMap<String, String>();
				sParaTemp.put("service", "trade_create_by_buyer");
		        sParaTemp.put("partner", AlipayConfig.partner);
		        sParaTemp.put("_input_charset", AlipayConfig.input_charset);
				sParaTemp.put("payment_type", payment_type);
				sParaTemp.put("notify_url", notify_url);
				sParaTemp.put("return_url", return_url);
				sParaTemp.put("seller_email", seller_email);
				sParaTemp.put("out_trade_no", out_trade_no);
				sParaTemp.put("subject", subject);
				sParaTemp.put("price", price);
				sParaTemp.put("quantity", quantity);
				sParaTemp.put("logistics_fee", logistics_fee);
				sParaTemp.put("logistics_type", logistics_type);
				sParaTemp.put("logistics_payment", logistics_payment);
				sParaTemp.put("body", body);
				sParaTemp.put("show_url", show_url);
				sParaTemp.put("receive_name", receive_name);
				sParaTemp.put("receive_address", receive_address);
				sParaTemp.put("receive_zip", receive_zip);
				sParaTemp.put("receive_phone", receive_phone);
				sParaTemp.put("receive_mobile", receive_mobile);
				
				//建立请求
				String sHtmlText = AlipaySubmit.buildRequest(sParaTemp,"get","确认");
				setAttr("sHtmlText", sHtmlText);
				render("alipay_confirm.ftl");
			} else {
				renderHtml("没有权限");
			}
		} catch (Exception re) {
			log.error("确认订单失败", re);
			renderHtml("确认订单失败，请重试");
		}
	}
	
	/**
	 * 
	 * @description 支付宝异步回调 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 25, 2013 1:46:46 AM
	 */
	public void alipayCallBack(){
		try {
			alipay(2);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * 
	 * @description 支付宝网页回调 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 25, 2013 1:55:38 AM
	 */
	public void alipay(){
		try {
			alipay(1);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	/**
	 * 
	 * @description 支付宝回调接口
	 * @author shevliu
	 * @throws UnsupportedEncodingException 
	 * @email shevliu@gmail.com May 19, 2013 6:52:01 PM
	 */
	@Before(Tx.class)
	public void alipay(int callBackType) throws UnsupportedEncodingException {
		log.info("===========支付宝回调");
		HttpServletRequest request = getRequest() ;
		//获取支付宝GET过来反馈信息
		Map<String,String> params = new HashMap<String,String>();
		Map requestParams = request.getParameterMap();
		for (Iterator iter = requestParams.keySet().iterator(); iter.hasNext();) {
			String name = (String) iter.next();
			String[] values = (String[]) requestParams.get(name);
			String valueStr = "";
			for (int i = 0; i < values.length; i++) {
				valueStr = (i == values.length - 1) ? valueStr + values[i]
						: valueStr + values[i] + ",";
			}
			//乱码解决，这段代码在出现乱码时使用。如果mysign和sign不相等也可以使用这段代码转化
//			valueStr = new String(valueStr.getBytes("ISO-8859-1"), "utf-8");
			params.put(name, valueStr);
		}
		
		//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以下仅供参考)//
		//商户订单号

		String out_trade_no = request.getParameter("out_trade_no");
//		String out_trade_no = new String(request.getParameter("out_trade_no").getBytes("ISO-8859-1"),"GBK");

		//支付宝交易号

		String trade_no = request.getParameter("trade_no");

		//交易状态
		String trade_status = request.getParameter("trade_status");
		log.info("===========支付宝回调 trade_status=" + trade_status);
		//获取支付宝的通知返回参数，可参考技术文档中页面跳转同步通知参数列表(以上仅供参考)//
		
		//计算得出通知验证结果
		boolean verify_result = AlipayNotify.verify(params);
		
		if(verify_result){//验证成功
			log.info("===========支付宝回调 验证成功");
			//////////////////////////////////////////////////////////////////////////////////////////
			//请在这里加上商户的业务逻辑程序代码
			//——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
			
			if(trade_status.equals("WAIT_SELLER_SEND_GOODS") || trade_status.equals("TRADE_FINISHED")){
				//判断该笔订单是否在商户网站中已经做过处理
					//如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
					//如果有做过处理，不执行商户的业务程序
				//注意这里，用到了forupdate进行锁定，避免重复执行
				Pay pay = Pay.dao.findFirst("select * from logistics_pay where id = ? for update" , NumberUtils.toInt(out_trade_no)) ;
				
				if(pay.getInt("status") == Pay.STATUS_CREATE  ){
					//当回调状态为成功时，更新支付表状态，并给用户充值
					pay.set("status", Pay.STATUS_SUCCESS);
					pay.set("finish_time", new Date());
					pay.set("platform_order", trade_no);
					pay.update();
					double recharge = pay.getDouble("pay_money");
					String u_id = pay.getStr("u_id");
					//货主充值
					if(u_id.startsWith("u")){
						int userId = NumberUtils.toInt(StringUtils.substringAfter(u_id, "u")) ;
						User user = User.dao.findById(userId);
						double beforeMoney = user.get("gold") == null ? 0 : user.getDouble("gold");
						double afterMoney = beforeMoney + recharge ;
						Db.update("update logistics_user set gold = ? where id = ?" , afterMoney ,userId );
						String businessSql = "insert into logistics_business (business_target , account , business_type , business_amount , before_balance , after_balance , create_time , system_user_id) values (?,?,?,?,?,?,?,?)" ;
						Db.update(businessSql , Business.TARGET_TYPE_USER , userId , Business.BUSINESS_TYPE_RECHARGE , recharge , beforeMoney , afterMoney , new Date(),null);
						Msg.dao.addUserMsg(Msg.TYPE_BUSINIESS, "充值成功", "支付宝支付成功，充值金额:" + recharge, userId);
					}
					//司机充值
					else if(u_id.startsWith("d")){
						int driverId = NumberUtils.toInt(StringUtils.substringAfter(u_id, "u")) ;
						Driver driver = Driver.dao.findById(driverId);
						double beforeMoney = driver.getDouble("gold");
						double afterMoney = beforeMoney + recharge ;
						Db.update("update logistics_driver set gold = ? where id = ?" , afterMoney ,driverId );
						String businessSql = "insert into logistics_business (business_target , account , business_type , business_amount , before_balance , after_balance , create_time , system_user_id) values (?,?,?,?,?,?,?,?)" ;
						Db.update(businessSql , Business.TARGET_TYPE_DRIVER , driverId , Business.BUSINESS_TYPE_RECHARGE , recharge , beforeMoney , afterMoney , new Date(),null);
						Msg.dao.addDriverMsg(Msg.TYPE_BUSINIESS, "充值成功", "支付宝支付成功，充值金额:" + recharge, driverId);
					}
					
				}
				if(callBackType == 1) {
					setAttr("pay", pay);
					render("pay_ok.ftl");
					// 产品通用接口支付成功返回-服务器点对点通讯
				} else if(callBackType == 2) {
					// 如果在发起交易请求时	设置使用应答机制时，必须应答以success
					renderHtml("success");
				}
			}
			
			//该判断表示买家已在支付宝交易管理中产生了交易记录，但没有付款
			//该判断表示卖家已经发了货，但买家还没有做确认收货的操作
			else{
				renderHtml("success");
			}
			
		}else{
			log.info("===========支付宝回调 验证失败");
			renderHtml("交易签名被篡改!");
		}
	}
	
	/**
	 * 
	 * @description 充值记录页面 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 26, 2013 5:02:10 PM
	 */
	public void payList(){
		render("pay_history.ftl");
	}
	
	/**
	 * 
	 * @description 充值记录 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 26, 2013 4:43:45 PM
	 */
	public void payHistory(){
		int userId = getUserId();
		Page<Pay> page = Pay.dao.getUserPayList(userId, getPageIndex(), getPageSize());
		renderJson(JSONUtils.toPagedGridJSONString(page, "pay_money|pay_platform|pay_channel|status|create_time|finish_time|remark"));
	}

}
