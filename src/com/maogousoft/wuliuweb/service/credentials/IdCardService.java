/**
 * @filename IdCardService.java
 */
package com.maogousoft.wuliuweb.service.credentials;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.util.StringUtils;

import com.maogousoft.wuliuweb.common.BaseConfig;
import com.maogousoft.wuliuweb.common.utils.TimeUtil;
import com.maogousoft.wuliuweb.service.FileInfo;
import com.maogousoft.wuliuweb.service.ImageService;

import sun.misc.BASE64Decoder;


/**
 * @description 身份验证接口
 * @author shevliu
 * @email shevliu@gmail.com
 * May 26, 2013 2:15:38 PM
 */
public class IdCardService {

	public static Map<String, String> validate(String idCard , String name ){
		String result = new IdVerifyService().getIdVerifyServiceHttpPort().verifyService("cdyy", "e598gf47r", "1", idCard, name, "02", System.currentTimeMillis()+"");
		Map<String, String> map = readXml(result);
		return map ;
	 }
	
	private static Map<String, String> readXml(String str) {
		Map<String, String> map = new HashMap<String, String>();
		try {
			Document doc = DocumentHelper.parseText(str);
			Element root = doc.getRootElement();
			List<Element> list = root.elements();
			for (Element e : list) {
				map.put(e.getName(), e.getText());
			}
		} catch (DocumentException e1) {
			e1.printStackTrace();
		}
		return map;
	}
	
	public static void main(String args[]){
//		System.out.println(validate("511112198410080516" , "刘鹏飞"));
		String str = "1980/06/26";
		Date date = TimeUtil.parse(str, "yyyy/MM/dd", null);
		System.out.println(date);
	}
	
}
