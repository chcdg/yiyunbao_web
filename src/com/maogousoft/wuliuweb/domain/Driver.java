/**
 * @filename Driver.java
 */
package com.maogousoft.wuliuweb.domain;

import com.maogousoft.wuliuweb.common.exception.BusinessException;


/**
 * @description 司机
 * @author shevliu
 * @email shevliu@gmail.com
 * Apr 30, 2013 4:42:00 PM
 */
public class Driver extends BaseModel<Driver> {

	private static final long serialVersionUID = 4992846090322426667L;

	public static final Driver dao = new Driver();

	/**
	 * 根据ID载入司机信息，如果不存在，则抛出异常
	 * @param driver_id
	 * @return
	 */
	public Driver loadDriverById(int driver_id) {
		Driver driver = dao.findById(driver_id);
		if(driver == null) {
			throw new BusinessException("司机不存在[" + driver_id + "]");
		}
		return driver;
	}

	/**
	 * 调整司机物流币
	 * @param amount
	 */
	public GoldResult adjustGold(double amount) {
		GoldResult result = new GoldResult();
		double gold = this.asDoubleValue("gold", 0);
		result.setBeforeGold(gold);

		gold = gold + amount;
		this.set("gold", gold);
		this.update();

		result.setAfterGold(gold);

		return result;
	}

	/**
	 * 根据号码获取司机信息
	 * @param phone
	 * @return
	 */
	public Driver findByPhone(String phone) {
		return dao.findFirst("select * from logistics_driver where phone=?", phone);
	}

}
