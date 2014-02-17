/**
 * @filename Order.java
 */
package com.maogousoft.wuliuweb.domain;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.plugin.activerecord.Model;

/**
 * @description 订单
 * @author shevliu
 * @email shevliu@gmail.com
 * Mar 18, 2013 9:50:56 PM
 */
public class Order extends BaseModel<Order>{

	/**
	 * 已删除
	 */
	public static int STATUS_DELETED = -1 ;

	/**
	 * 已创建，待审核
	 */
	public static int STATUS_CREATED = 0 ;

	/**
	 * 审核通过，待抢单
	 */
	public static int STATUS_PASS = 1 ;

	/**
	 * 审核未通过
	 */
	public static int STATUS_REJECT = 2 ;

	/**
	 * 已中标，订单执行中
	 */
	public static int STATUS_DEAL = 3;

	/**
	 * 未达成条件，已正常取消
	 */
	public static int STATUS_CANCEL = 4;

	/**
	 * 订单已完成
	 */
	public static int STATUS_FINISH = 99;

	/**
	 * 订单已过期
	 */
	public static int STATUS_EXPIRED = 98 ;

	public static final Order dao = new Order();

	/**
	 *
	 * @description 获取除删除以外的所有状态list
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 18, 2013 10:02:06 PM
	 * @return
	 */
	public static List<Map<String , String>> getAllStatus(){
		List<Map<String , String>> list = new ArrayList<Map<String,String>>();
		list.add(createStatus(STATUS_CREATED, "已创建"));
		list.add(createStatus(STATUS_PASS, "审核通过"));
		list.add(createStatus(STATUS_REJECT, "审核未通过"));
		list.add(createStatus(STATUS_CANCEL, "已取消"));
		list.add(createStatus(STATUS_DEAL, "已中标，进行中"));
		list.add(createStatus(STATUS_FINISH, "订单已完成"));
		return list ;
	}

	private static Map<String , String> createStatus(int status , String text){
		Map<String , String> map = new HashMap<String , String>();
		map.put("status", status + "") ;
		map.put("text", text);
		return map ;
	}

	public boolean isStauts(int expectedStatus) {
		final int orderStatus = this.getInt("status");
		return orderStatus == expectedStatus;
	}

	/**
	 * 判断订单的货主拥有者
	 * @param user_id
	 * @return
	 */
	public boolean isOwner(int user_id) {
		final int orderUserId = this.getInt("user_id");
		if(orderUserId == user_id) {
			return true;
		}
		return false;
	}

	/**
	 * 获取信息费，每笔为运费的3%，最高不超过200
	 * @return
	 */
	public double getFee() {
		double price = this.get("price");
		return Math.min(price * 0.03, 200);
	}

	/**
	 * 调整抢单人数
	 * @param i
	 */
	public void adjustVieCount(int i) {
		int vie_driver_count = this.getInt("vie_driver_count");
		vie_driver_count += i;
		this.set("vie_driver_count", vie_driver_count);
		this.update();
	}
}
