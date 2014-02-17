/**
 * @filename AuthInterceptor.java
 */
package com.maogousoft.wuliuweb.interceptor;

import java.io.PrintWriter;
import java.io.StringWriter;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.jfinal.aop.Interceptor;
import com.jfinal.core.ActionInvocation;
import com.jfinal.core.Controller;

/**
 * 异常拦截
 */
public class ExceptionInterceptor implements Interceptor{

	private Logger log = LoggerFactory.getLogger(ExceptionInterceptor.class) ;


	public void intercept(ActionInvocation ai) {
		try{
			ai.invoke();
		}catch(Throwable re){
			log.error("业务处理异常:" , re);
			String message = re.getMessage();
			if(StringUtils.isBlank(message)) {
				message = "未知错误:" + re.getClass();
			}

			Controller c = ai.getController();
			HttpServletRequest request =  c.getRequest();

			//判断是否是ajax
			String requestedWith = request.getHeader("X-Requested-With");
			if(StringUtils.isNotBlank(requestedWith) && requestedWith.equals("XMLHttpRequest")) {
				try {
//					c.getResponse().sendError(500, message);
					JSONObject json = new JSONObject();
					json.accumulate("success", false);
					json.accumulate("message", message);
					json.accumulate("data", message);
					c.renderText(json.toString());
				} catch (Exception e) {
					log.error(e.getMessage(),e);
				}
			}else {
				c.setAttr("message", message);
				c.setAttr("exception", re);
				StringWriter sw = new StringWriter();
				re.printStackTrace(new PrintWriter(sw));
				c.setAttr("detail", sw);
				c.render("/WEB-INF/pages/error.ftl");
			}
		}
	}

}
