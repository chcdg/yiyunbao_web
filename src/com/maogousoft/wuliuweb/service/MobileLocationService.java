/**
 * @filename MobileLocationService.java
 */
package com.maogousoft.wuliuweb.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.message.BasicNameValuePair;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.maogousoft.wuliuweb.common.utils.HttpUtils;

/**
 * @description 手机定位接口
 * @author shevliu
 * @email shevliu@gmail.com May 13, 2013 10:18:15 PM
 */
public class MobileLocationService {

	private static final String url = "http://121.101.212.58:7003/LbsLogistics.asmx";

	private static final String companyId = "yykj";

	private static final String companyPwd = "q2AuVee5+UumWpzf7U8WJQ==";

	// 用户类型：人员
	private static final String userType = "1";

	// 操作类型，删除
	private static final String OPT_TYPE_DELETE = "0";

	// 操作类型：添加
	private static final String OPT_TYPE_ADD = "1";

	// 操作类型：查询
	private static final String OPT_TYPE_QUERY = "2";

	/**
	 * 
	 * @description 查询手机注册状态
	 * @author shevliu
	 * @email shevliu@gmail.com May 13, 2013 11:01:14 PM
	 * @param mobile
	 * @param userName
	 * @return
	 */
	public static Map<String, String> queryUser(String mobile, String userName) {
		return sendList(mobile, userName, OPT_TYPE_QUERY);
	}

	/**
	 * 
	 * @description 注册手机
	 * @author shevliu
	 * @email shevliu@gmail.com May 13, 2013 11:01:26 PM
	 * @param mobile
	 * @param userName
	 * @return
	 */
	public static Map<String, String> registUser(String mobile, String userName) {
		return sendList(mobile, userName, OPT_TYPE_ADD);
	}

	private static Map<String, String> sendList(String mobile, String userName,
			String optType) {
		List<BasicNameValuePair> params = new ArrayList<BasicNameValuePair>();
		params.add(new BasicNameValuePair("companyid", companyId));
		params.add(new BasicNameValuePair("companypwd", companyPwd));
		params.add(new BasicNameValuePair("usertype", userType));
		params.add(new BasicNameValuePair("mobile", mobile));
		params.add(new BasicNameValuePair("username", userName));
		params.add(new BasicNameValuePair("opertype", optType));
		String str = HttpUtils.post(url + "/sendList", params);

		return readXml(str);
	}

	
	/**
	 * 
	 * @description 立即定位 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 14, 2013 12:01:56 AM
	 * @param mobile
	 * @return
	 */
	public static Map<String, String> location(String mobile){
		List<BasicNameValuePair> params = new ArrayList<BasicNameValuePair>();
		params.add(new BasicNameValuePair("companyid", companyId));
		params.add(new BasicNameValuePair("companypwd", companyPwd));
		params.add(new BasicNameValuePair("mobile", mobile));
		params.add(new BasicNameValuePair("opertype", "1"));
		String str = HttpUtils.post(url + "/sendLocation", params);
		return readXml(str);
	}
	
	private static Map<String, String> readXml(String str) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			Document doc = DocumentHelper.parseText(str);
			Element root = doc.getRootElement();
			String newXML = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
			newXML += root.getText();

			Document doc2 = DocumentHelper.parseText(newXML);
			Element root2 = doc2.getRootElement();
			List<Element> list = root2.elements();
			for (Element e : list) {
				map.put(e.attribute("name").getValue(), e.attribute("value")
						.getValue());
			}
		} catch (DocumentException e1) {
			e1.printStackTrace();
		}
		return map;
	}

	public static void main(String args[]) {
		System.out.println(queryUser("13880658892", "11"));
		System.out.println(registUser("13880658892", "11"));
	}
}
