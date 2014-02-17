package com.maogousoft.wuliuweb.common;

import com.jfinal.config.Constants;
import com.jfinal.config.Handlers;
import com.jfinal.config.Interceptors;
import com.jfinal.config.JFinalConfig;
import com.jfinal.config.Plugins;
import com.jfinal.config.Routes;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.c3p0.C3p0Plugin;
import com.jfinal.plugin.ehcache.EhCachePlugin;
import com.maogousoft.wuliuweb.common.utils.SchedulerUtil;
import com.maogousoft.wuliuweb.controller.AccountController;
import com.maogousoft.wuliuweb.controller.DictController;
import com.maogousoft.wuliuweb.controller.DriverReplyController;
import com.maogousoft.wuliuweb.controller.FleetController;
import com.maogousoft.wuliuweb.controller.IndexController;
import com.maogousoft.wuliuweb.controller.InsuranceController;
import com.maogousoft.wuliuweb.controller.MobileLocationController;
import com.maogousoft.wuliuweb.controller.MsgController;
import com.maogousoft.wuliuweb.controller.OrderController;
import com.maogousoft.wuliuweb.controller.OtherController;
import com.maogousoft.wuliuweb.controller.PayController;
import com.maogousoft.wuliuweb.controller.PhotoController;
import com.maogousoft.wuliuweb.controller.VerifyController;
import com.maogousoft.wuliuweb.domain.Ad;
import com.maogousoft.wuliuweb.domain.Area;
import com.maogousoft.wuliuweb.domain.Business;
import com.maogousoft.wuliuweb.domain.Coupon;
import com.maogousoft.wuliuweb.domain.Dict;
import com.maogousoft.wuliuweb.domain.Driver;
import com.maogousoft.wuliuweb.domain.DriverReply;
import com.maogousoft.wuliuweb.domain.Fleet;
import com.maogousoft.wuliuweb.domain.IdCard;
import com.maogousoft.wuliuweb.domain.InsuranceCargoType;
import com.maogousoft.wuliuweb.domain.Msg;
import com.maogousoft.wuliuweb.domain.Order;
import com.maogousoft.wuliuweb.domain.OrderLog;
import com.maogousoft.wuliuweb.domain.OrderTemplet;
import com.maogousoft.wuliuweb.domain.OrderVie;
import com.maogousoft.wuliuweb.domain.Pay;
import com.maogousoft.wuliuweb.domain.User;
import com.maogousoft.wuliuweb.domain.UserReply;
import com.maogousoft.wuliuweb.interceptor.ExceptionInterceptor;

/**
 * @description 基础配置信息
 * @author shevliu
 * @email shevliu@gmail.com Jul 26, 2012 9:26:46 PM
 */
public class BaseConfig extends JFinalConfig {

	private static BaseConfig me;

	public BaseConfig() {
		super();
		me = this;
		initQuartz();
	}
	
	/**
	 * 初始化Quartz定时任务
	 */
	private void  initQuartz(){
		SchedulerUtil st = new SchedulerUtil();
		st.toBeginScheduler();
	}

	public static BaseConfig me() {
		return me;
	}

	/**
	 *
	 */
	@Override
	public void configConstant(Constants me) {
		loadPropertyFile("config.properties");
		me.setFreeMarkerViewExtension(".ftl");
		me.setBaseViewPath("WEB-INF/pages");
		me.setDevMode(true);
	}

	@Override
	public void configHandler(Handlers me) {
	}

	@Override
	public void configInterceptor(Interceptors me) {
		me.add(new ExceptionInterceptor());
	}

	@Override
	public void configPlugin(Plugins me) {

		// 配置C3p0数据库连接池插件
		C3p0Plugin c3p0Plugin = new C3p0Plugin(getProperty("jdbcUrl"), getProperty("user"), getProperty("password"), getProperty("jdbc.driverClass"));
		me.add(c3p0Plugin);

		// 配置ActiveRecord插件
		ActiveRecordPlugin arp = new ActiveRecordPlugin(c3p0Plugin);
		me.add(arp);
		arp.setShowSql(true);

		arp.addMapping("logistics_area", Area.class);
		arp.addMapping("logistics_dict", Dict.class);
		arp.addMapping("logistics_user", User.class);
		arp.addMapping("logistics_fleet", Fleet.class);
		arp.addMapping("logistics_driver", Driver.class);
		arp.addMapping("logistics_order", Order.class);
		arp.addMapping("logistics_order_templet", OrderTemplet.class);
		arp.addMapping("logistics_order_vie", OrderVie.class);
		arp.addMapping("logistics_ad", Ad.class);
		arp.addMapping("log_order", OrderLog.class);
		arp.addMapping("logistics_user_reply", UserReply.class);
		arp.addMapping("logistics_driver_reply", DriverReply.class);
		arp.addMapping("logistics_pay", Pay.class);
		arp.addMapping("logistics_business", Business.class);
		arp.addMapping("logistics_idcard", IdCard.class);
		arp.addMapping("logistics_sys_msg", Msg.class);
		arp.addMapping("logistics_coupon", Coupon.class);
		arp.addMapping("insurance_cargo_type", InsuranceCargoType.class);


		//配置缓存
		EhCachePlugin cachePlugin = new EhCachePlugin();
		me.add(cachePlugin);
	}

	@Override
	public void configRoute(Routes me) {
		me.add("/" , IndexController.class);
		me.add("/order" , OrderController.class);
		me.add("/dict" , DictController.class);
		me.add("/fleet" , FleetController.class);
		me.add("/verify" , VerifyController.class);
		me.add("/insurance" , InsuranceController.class);
		me.add("/photo" , PhotoController.class);
		me.add("/other" , OtherController.class);
		me.add("/account" , AccountController.class);
		me.add("/msg" , MsgController.class);
		me.add("/mobileLocation" , MobileLocationController.class);
		me.add("/pay" , PayController.class);
		me.add("/driverReply" , DriverReplyController.class);
	}

}
