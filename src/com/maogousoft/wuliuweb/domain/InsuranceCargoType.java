/**
 * @filename Ad.java
 */
package com.maogousoft.wuliuweb.domain;

import java.util.List;


/**
 * @description 保险-货物类别
 * @author shevliu
 * @email shevliu@gmail.com
 * May 18, 2013 11:55:40 PM
 */
public class InsuranceCargoType extends BaseModel<InsuranceCargoType>{

	private static final long serialVersionUID = 9061772848631797540L;
	
	public static final InsuranceCargoType dao = new InsuranceCargoType();
	
	/**
	 * 
	 * @description 获取一级类别 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * 2013年9月5日 上午12:24:50
	 * @return
	 */
	public List<InsuranceCargoType> getAllFirstType(){
		List<InsuranceCargoType> list = InsuranceCargoType.dao.find("select * from insurance_cargo_type where pid = 0  order by id desc");
		return list ;
	}
	
	/**
	 * 
	 * @description 获取二级类别 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * 2013年9月5日 上午12:24:59
	 * @param pid
	 * @return
	 */
	public List<InsuranceCargoType> getSecondFirstType(int pid){
		List<InsuranceCargoType> list = InsuranceCargoType.dao.find("select * from insurance_cargo_type where pid = ?  order by id " , pid);
		return list ;
	}
}
