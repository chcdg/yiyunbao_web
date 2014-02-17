/**
 * @filename Ad.java
 */
package com.maogousoft.wuliuweb.domain;

import java.util.List;

/**
 * @description 广告位
 * @author shevliu
 * @email shevliu@gmail.com
 * May 18, 2013 11:55:40 PM
 */
public class Ad extends BaseModel<Ad>{

	private static final long serialVersionUID = 9061772848631797540L;
	
	public static final Ad dao = new Ad();
	
	/**
	 * 
	 * @description 根据位置和条数查询广告位信息 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 19, 2013 1:23:11 AM
	 * @param location
	 * @param size
	 * @return
	 */
	public static List<Ad> getLastAd(int location , int size){
		String sql = "select * from logistics_ad where ad_location = ? and status = 0 order by id desc limit ?" ;
		return dao.find(sql , location ,size);
	}
}
