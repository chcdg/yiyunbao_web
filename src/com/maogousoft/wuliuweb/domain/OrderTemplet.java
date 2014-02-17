/**
 * @filename Order.java
 */
package com.maogousoft.wuliuweb.domain;

import java.util.List;



/**
 * @description 订单模板
 */
public class OrderTemplet extends BaseModel<OrderTemplet>{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	public static final OrderTemplet dao = new OrderTemplet();
	
	public List<OrderTemplet> findOrderTempletByUserId(int userId){
		String sql = "select * from logistics_order_templet t where t.user_id = "+userId;
		List<OrderTemplet> list = dao.find(sql);
		return list;
	}
	
	public List<OrderTemplet> findOrderTempletByName(String tempName,int user_id){
		String sql = "select * from logistics_order_templet t where t.templet_name = '"+tempName+"' and t.user_id = "+user_id;
		List<OrderTemplet> list = dao.find(sql);
		return list;
	}
	
	public boolean delTempletOrderByName(String tempName,int user_id){
		String sql = "select * from logistics_order_templet t where t.templet_name = '"+tempName+"' and t.user_id = "+user_id;
		List<OrderTemplet> list = dao.find(sql);
		OrderTemplet ot = list.get(0);
		boolean flag = ot.delete();
		return flag;
	}
}
