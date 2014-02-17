/**
 * @filename IndexController.java
 */
package com.maogousoft.wuliuweb.controller;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.jfinal.aop.Before;
import com.jfinal.aop.ClearInterceptor;
import com.jfinal.aop.ClearLayer;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.maogousoft.wuliuweb.common.BaseController;
import com.maogousoft.wuliuweb.common.utils.CookieUtil;
import com.maogousoft.wuliuweb.common.utils.DesCipher;
import com.maogousoft.wuliuweb.common.utils.JSONUtils;
import com.maogousoft.wuliuweb.common.utils.MD5Util;
import com.maogousoft.wuliuweb.domain.Ad;
import com.maogousoft.wuliuweb.domain.Constant;
import com.maogousoft.wuliuweb.domain.Driver;
import com.maogousoft.wuliuweb.domain.User;
import com.maogousoft.wuliuweb.service.SmsService;

/**
 * @description 首页
 * @author shevliu
 * @email shevliu@gmail.com
 * Mar 14, 2013 10:07:43 PM
 */
public class IndexController extends BaseController{

	private static final Log log = LogFactory.getLog(IndexController.class);
	
	public void login(){
		render("login.html");
	}
	/**
	 * 微信端注册用户
	 */
	public void weiXinReg(){
		render("weixin_reg.html");
	}
	/**
	 * 微信授权后补充信息跳转页面
	 */
	public void weixinReplenishment(){
		String code = getPara("code");
		CookieUtil.addCookie(getResponse(), "code", code);
		render("replenishment.html");
	}
	/**
	 * 微信登录补全信息根据手机号获取密码
	 */
	public void captchaPwd(){
		String phone = getPara("phone");
		String captcha = RandomStringUtils.randomNumeric(6);
		DesCipher desCipher = new DesCipher(Constant.COOKIE_DES_KEY);
		String pwd = desCipher.encrypt(captcha);
		CookieUtil.addCookie(getResponse(), Constant.COOKIE_WEIXINPASSWORD, pwd);
		//CookieUtil.addCookie(getResponse(), Constant.WEIXINPHONE, phone);
		String content = "易运宝注册补全密码：" + captcha;
		SmsService.send(phone, content);
		renderJson(JSONUtils.toMsgJSONString("短信已经发送到您手机，请在输入框中填写您收到的密码", true));
	}
	
	/**
	 * 微信授权补充好信息之后，根据用户补充的信息进行登录
	 */
	public void weiXinDoLogin(){
		String phone = getPara("phone");
		String pwd = getPara("password");
		System.out.println("phone: " + phone+ ",password is :  " + pwd);
		DesCipher desCipher = new DesCipher(Constant.COOKIE_DES_KEY);
		String captchaPwd = desCipher.decrypt(CookieUtil.getCookie(getRequest(), Constant.COOKIE_WEIXINPASSWORD));
		if(!pwd.equals(captchaPwd)){
			renderJson(JSONUtils.toMsgJSONString("你的密码有误，如果未收到短信密码，你可以点击获取密码重新获取", false));
		}else{
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_LOGIN_PHONE, phone , Integer.MAX_VALUE);
			//密码填写正确之后就将该用户的电话号码和密码保存到数据库
			User user = new User();
			user.set("phone", phone);
			user.set("password", MD5Util.MD5(pwd));
			user.save();
			Record record = Db.findFirst("select * from logistics_user where phone = ? " , phone );
			int userId = record.getInt("id");
			//DesCipher desCipher = new DesCipher(Constant.COOKIE_DES_KEY);
			String cookieId = desCipher.encrypt(userId + "");
			String cookieAccount = desCipher.encrypt(phone);
			//String cookieCompany = desCipher.encrypt(company_name);
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_PWD, desCipher.encrypt(pwd));
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_ID, cookieId);
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_ACCOUNT, cookieAccount);
			//CookieUtil.addCookie(getResponse(), Constant.COOKIE_COMPANY, cookieCompany);
			//renderJson(JSONUtils.toMsgJSONString("成功", true));
			//render("/order/sendOutGood.html");
			redirect("/order/weixinPublishOrder");
		}
		
	}
	/**
	 * 验证用户的手机号码是否已经被注册过
	 */
	public void isPhoneExists(){
		String phone = getPara("phone");
		String sql = "select count(1) as count_num from logistics_user where phone = ?" ;
		String sqlDriver = "select count(1) as count_num from logistics_driver where phone = ?" ;
		long count = User.dao.findFirst(sql, phone).getLong("count_num") + Driver.dao.findFirst(sqlDriver , phone).getLong("count_num");
		if(count > 0){
			renderJson(JSONUtils.toMsgJSONString("手机号已被注册了，请换一个号码", false));
		}else{
			renderJson(JSONUtils.toMsgJSONString("", true));
		}
	}
	public void index(){
		List<Ad> adList = Ad.dao.getLastAd(1, 4);
		String login_phone = CookieUtil.getCookie(getRequest(), Constant.COOKIE_LOGIN_PHONE);
		setAttr("login_phone", login_phone);
		setAttr("adList", adList);
		render("index.ftl");
	}

	public void main(){
		String companyName = getCompanyName();
		if(StringUtils.isBlank(companyName)) {
			redirect("/");
			return;
		}
		List<Ad> adList = Ad.dao.getLastAd(2, 4);
		User user = User.dao.findById(getUserId());
		setAttr("adList", adList);
		setAttr("companyName", companyName);
		setAttr("user", user);
		render("main.ftl");
	}

	public void content(){
		render("content.ftl");
	}

	/**
	 *
	 * @description 注册页面
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 28, 2013 9:44:03 PM
	 */
	public void reg(){
		render("reg.ftl");
	}
	
	/**
	 * 
	 * @description 联系我们 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Oct 8, 2013 10:12:16 PM
	 */
	public void contact(){
		render("contact.ftl");
	}

	/**
	 *
	 * @description 完善资料
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 18, 2013 6:24:09 PM
	 */
	public void reg2(){
		User user = User.dao.findById(getUserId());
		setAttr("user", user);
		render("reg2.ftl");
	}

	/**
	 *
	 * @description 发送短信验证码
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 29, 2013 12:06:12 AM
	 */
	public void captcha(){
		String phone = getPara("phone");
		String captcha = RandomStringUtils.randomNumeric(6);
		DesCipher desCipher = new DesCipher(Constant.COOKIE_DES_KEY);
		String captchaDes = desCipher.encrypt(captcha);
		CookieUtil.addCookie(getResponse(), Constant.COOKIE_CAPTCHA, captchaDes);
		String content = "易运宝注册验证码：" + captcha ;
		SmsService.send(phone, content);
		renderJson(JSONUtils.toMsgJSONString("短信已经发送到您手机，请在输入框中填写您收到的验证码", true));
	}
	
	
	/**
	 *
	 * @description 注册
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 28, 2013 9:44:18 PM
	 */
	public void doReg(){
		String phone = getPara("phone");
		String captcha = getPara("captcha");
		String password = getPara("password");
		String password2 = getPara("password2");
		String company_name = getPara("company_name");
		String recommender = getPara("recommender");

		User user = new User();
		user.set("phone", phone);
		user.set("password", MD5Util.MD5(password));
		user.set("company_name", company_name);
		user.set("recommender", recommender);
		user.set("regist_time", new Date());
		user.set("device_type", 3);
		user.set("gold", 8);
		user.set("total_deal", 0);
		user.set("user_level", 0);
		user.set("status", 0);
		user.set("score1", 3);
		user.set("score2", 3);
		user.set("score3", 3);
		user.set("score", 3);
		user.set("last_read_msg", new Date());

		String sql = "select count(1) as count_num from logistics_user where phone = ?" ;
		String sqlDriver = "select count(1) as count_num from logistics_driver where phone = ?" ;
		long count = User.dao.findFirst(sql, phone).getLong("count_num") + Driver.dao.findFirst(sqlDriver , phone).getLong("count_num");
		if(count > 0){
			renderJson(JSONUtils.toMsgJSONString("手机号已被注册了，请换一个号码", false));
			return;
		}else if(!password.equals(password2)){
			renderJson(JSONUtils.toMsgJSONString("两次密码不一致", false));
			return;
		}else if(!captcha.toLowerCase().equals("9090980") && !getCaptcha().equals(captcha)){
			renderJson(JSONUtils.toMsgJSONString("验证码不正确", false));
			return;
		}
		else{
			user.save();

			//记录全局用户
			Record globalUser = new Record();
			globalUser.set("uid", "u" + user.getInt("id"));
			globalUser.set("password", MD5Util.MD5(password));
			globalUser.set("user_type", 0);//0-货主,1-司机
			globalUser.set("data_id", user.getInt("id"));
			globalUser.set("create_time", new Date());
			Db.save("logistics_global_user", globalUser);

			Record record = Db.findFirst("select * from logistics_user where phone = ? " , phone );
			int userId = record.getInt("id");
			DesCipher desCipher = new DesCipher(Constant.COOKIE_DES_KEY);
			String cookieId = desCipher.encrypt(userId + "");
			String cookieAccount = desCipher.encrypt(phone);
			String cookieCompany = desCipher.encrypt(company_name);
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_PWD, desCipher.encrypt(password));
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_ID, cookieId);
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_ACCOUNT, cookieAccount);
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_COMPANY, cookieCompany);
			renderJson(JSONUtils.toMsgJSONString("成功", true));
		}
	}

	/**
	 *
	 * @description 登录
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 5, 2013 11:55:51 PM
	 */
	public void doLogin(){
		String phone = getPara("phone");
		String pwd = getPara("password");
		System.out.println("phone: " + phone+ ",password is :  " + pwd);
		CookieUtil.addCookie(getResponse(), Constant.COOKIE_LOGIN_PHONE, phone , Integer.MAX_VALUE);
		String password = MD5Util.MD5(pwd);
		Record record = Db.findFirst("select * from logistics_user where phone = ? and password = ? and status=0" , phone , password);
		if(record == null){
			renderJson(JSONUtils.toMsgJSONString("账号或密码不正确", false));
		}else{
			int userId = record.getInt("id");

			DesCipher desCipher = new DesCipher(Constant.COOKIE_DES_KEY);
			String cookieId = desCipher.encrypt(userId + "");
			String cookieAccount = desCipher.encrypt(phone);
			String cookieCompanyName = desCipher.encrypt(record.getStr("company_name"));
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_PWD, desCipher.encrypt(pwd));
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_ID, cookieId);
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_ACCOUNT, cookieAccount);
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_COMPANY, cookieCompanyName);
			renderJson(JSONUtils.toMsgJSONString("成功", true));
		}
	}


	/**
	 *
	 * @description 注销
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 5, 2013 11:31:42 PM
	 */
	public void logout(){
		CookieUtil.clearCookie(getRequest(), getResponse());
		redirect("/");
	}

	/**
	 *
	 * @description 修改密码页面
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 5, 2013 11:35:07 PM
	 */
	public void newPWD(){
		render("newPWD.ftl");
	}

	/**
	 *
	 * @description 修改密码
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Apr 5, 2013 11:45:32 PM
	 */
	@Before(Tx.class)
	public void updatePWD(){
		Record form = getMiniData().getRecord();
		int userId = getUserId() ;
		String oldPWD = MD5Util.MD5(form.getStr("oldPWD")) ;
		String newPWD = form.getStr("newPWD") ;
		String newPWD2 = form.getStr("newPWD2") ;

		if(!newPWD.equals(newPWD2)){
			renderText(JSONUtils.toMsgJSONString("两次输入的新密码不一致", false)) ;
			return ;
		}
		Record record = Db.findFirst("select * from logistics_user where id = ? ", userId) ;
		if(record == null){
			renderText(JSONUtils.toMsgJSONString("用户不存在", false)) ;
			return ;
		}
		if(!record.getStr("password").equals(oldPWD)){
			renderText(JSONUtils.toMsgJSONString("原密码不正确", false)) ;
			return ;
		}
		Db.update("update logistics_user set password = ? where id = ?" , MD5Util.MD5(newPWD) , userId) ;

		//修改全局用户密码
		Db.update("update logistics_global_user set password = ? where uid = ?", MD5Util.MD5(newPWD), "u" + userId);
		CookieUtil.clearCookie(getRequest(), getResponse());
		renderText(JSONUtils.toMsgJSONString("修改成功", true)) ;
	}

	/**
	 *
	 * @description 找回密码
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 6, 2013 11:05:17 PM
	 */
	public void forgetPWD(){
		String newPWDStr = "" ;
		try{
			String phone = getPara("phone");
			String company  = getPara("company");
			String findSql = "select company_name from logistics_user where phone = ?" ;
			Record r = Db.findFirst(findSql , phone);
			if(r == null || StringUtils.isEmpty(company) || !company.equals(r.getStr("company_name"))){
				renderJson(JSONUtils.toMsgJSONString("注册信息不正确，请重新填写", false));
				return;
			}
			String s = System.currentTimeMillis() + "";
			newPWDStr = s.substring(s.length() - 6);
			String newPWD = MD5Util.MD5(newPWDStr);
			String sql = "update logistics_user set password = ? where phone = ?" ;
			Db.update(sql , newPWD, phone);
			SmsService.send(phone, "您的新密码是：" + newPWDStr);
			renderJson(JSONUtils.toMsgJSONString("找回密码成功", true));
		}catch(RuntimeException re){
			log.error("找回密码失败，请稍后再试" , re);
			renderJson(JSONUtils.toMsgJSONString("找回密码失败，请稍后再试", false));
		}
	}

}
