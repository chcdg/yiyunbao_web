/**
 * @filename IdCard.java
 */
package com.maogousoft.wuliuweb.domain;

import com.jfinal.plugin.activerecord.Model;

/**
 * @description 
 * @author shevliu
 * @email shevliu@gmail.com
 * Jun 2, 2013 6:17:55 PM
 */
public class IdCard extends Model<IdCard>{

	private static final long serialVersionUID = -3479919136464883691L;
	
	public static final IdCard dao = new IdCard();
}
