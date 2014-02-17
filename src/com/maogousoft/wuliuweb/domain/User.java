/**
 * @filename User.java
 */
package com.maogousoft.wuliuweb.domain;

import com.maogousoft.wuliuweb.common.exception.BusinessException;


/**
 * @description 货主实体
 * @author shevliu
 * @email shevliu@gmail.com
 * Apr 28, 2013 10:21:42 PM
 */
public class User  extends BaseModel<User>{

	private static final long serialVersionUID = 1793102437666242279L;

	public static final User dao = new User();

	/**
	 * 根据ID载入货主信息，如果不存在，则抛出异常
	 * @param driver_id
	 * @return
	 */
	public User loadUserById(int user_id) {
		User user = dao.findById(user_id);
		if(user == null) {
			throw new BusinessException("货主不存在[" + user_id + "]");
		}
		return user;
	}

	/**
	 * 调整货主物流币
	 * @param amount
	 * @return 调整前与调整后的金额
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
}
