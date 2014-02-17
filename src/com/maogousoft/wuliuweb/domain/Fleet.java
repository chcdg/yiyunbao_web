/**
 * @filename Fleet.java
 */
package com.maogousoft.wuliuweb.domain;

import com.jfinal.plugin.activerecord.Model;

/**
 * @description  我的车队
 * @author shevliu
 * @email shevliu@gmail.com
 * Apr 30, 2013 12:10:47 PM
 */
public class Fleet extends Model<Fleet>{

	private static final long serialVersionUID = -6566933282487342664L;
	
	public static final Fleet dao = new Fleet();
}
