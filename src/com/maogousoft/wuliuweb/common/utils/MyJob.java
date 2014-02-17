package com.maogousoft.wuliuweb.common.utils;


import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.jfinal.plugin.activerecord.Db;
import com.maogousoft.wuliuweb.controller.OrderController;

public class MyJob implements Job{
	
	private static final Log log = LogFactory.getLog(OrderController.class) ;

	@Override
	//每月1号 1:00 更新logistics_driver表中的search_count数量
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		int flag = Db.update("update logistics_driver set search_count = 10");
		
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String nowTime = sdf.format(date);
		
		if(flag == 1){
			log.info("更新数据库<表>[logistics_driver]<字段>[search_count]为10 【成功】，时间："+nowTime);
		}else{
			log.error("更新数据库<表>[logistics_driver]<字段>[search_count]为10 【失败】，时间："+nowTime);
		}
		
	}

}
