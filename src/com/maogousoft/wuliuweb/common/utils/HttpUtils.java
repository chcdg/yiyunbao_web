/**
 * @filename HttpUtils.java
 */
package com.maogousoft.wuliuweb.common.utils;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

/**
 * @description http client 辅助类
 * @author shevliu
 * @email shevliu@gmail.com
 * May 13, 2013 10:21:39 PM
 */
public class HttpUtils {
	
	private static final Log log = LogFactory.getLog(HttpUtils.class);

	/**
	 * 
	 * @description get请求 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 13, 2013 10:30:18 PM
	 * @param url
	 * @return
	 */
	public static String get(String url) {
		HttpClient httpClient = new DefaultHttpClient();
		HttpUriRequest request = new HttpGet(url);
		try {
			HttpResponse response = httpClient.execute(request);
			if (response.getEntity() != null) {
				return EntityUtils.toString(response.getEntity());
			}
			return "";
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("请求失败,url:" + url , e);
		} 
	}
	
	/**
	 * 
	 * @description post请求，不带参数 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 13, 2013 10:31:51 PM
	 * @param url
	 * @return
	 */
	public static String post(String url){
		return post(url, new ArrayList<BasicNameValuePair>());
	}
	
	/**
	 * 
	 * @description post请求 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 13, 2013 10:30:11 PM
	 * @param url
	 * @param params
	 * @return
	 */
	public static String post(String url , List<BasicNameValuePair> params){
		HttpClient httpClient = new DefaultHttpClient();
		HttpPost request = new HttpPost(url);
		try {
			HttpEntity entity = new UrlEncodedFormEntity(params, "UTF-8");
			request.setEntity(entity);
			HttpResponse response = httpClient.execute(request);
			if (response.getEntity() != null) {
				return EntityUtils.toString(response.getEntity());
			}
			return "";
		} catch (Exception e) {
			log.error(e);
			throw new RuntimeException("请求失败,url:" + url , e);
		} 
	}
}
