package com.maogousoft.wuliuweb.controller;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.maogousoft.wuliuweb.common.BaseController;
import com.maogousoft.wuliuweb.common.utils.JSONUtils;
import com.maogousoft.wuliuweb.domain.Fleet;
import com.maogousoft.wuliuweb.domain.User;

/**
 * @author yangfan(kenny0x00@gmail.com) 2013-5-1 下午8:26:11
 */
public class MsgController extends BaseController {

	private static final Log log = LogFactory.getLog(MsgController.class);

	/**
	 *
	 * @description 信息中心首页，进入时将最后读取信息时间更新为当前
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 5, 2013 11:22:32 PM
	 */
	public void index() {
		int userId = getUserId();
		Date now = new Date();
		String sql = "update logistics_user set last_read_msg = ? where id = ? " ;
		Db.update(sql , now ,userId);
		render("msg_index.ftl");
	}

	/**
	 *
	 * @description 获取未读消息条数
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 5, 2013 10:18:47 PM
	 */
	public void getUnReadCount() {
		try {
			int userId = getUserId();
			User user = User.dao.findById(userId);
			String receiverId = "u" + userId;
			String sql = "select count(0) from logistics_sys_msg where ( u_id is null  or u_id = ? ) and msg_time > ? and status=0";
			long count = Db.queryLong(sql , receiverId , user.getTimestamp("last_read_msg"));
			renderJson(JSONUtils.toMsgJSONString(count + "", true));
		} catch (RuntimeException re) {
			log.error("查询消息条数失败" , re);
			renderJson(JSONUtils.toMsgJSONString("0", false));
		}
	}

	/**
	 *
	 * @description 查询列表
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 5, 2013 11:07:36 PM
	 */
	public void list(){
		String receiverId = "u" + getUserId();

		String select  = "select *  ";
		StringBuffer from = new StringBuffer();
		from.append("from logistics_sys_msg where ( u_id is null  or u_id = ? )  and status=0 order by id desc ") ;

		Page<Record> page = Db.paginate(getPageIndex(), getPageSize(), select , from.toString() ,receiverId );
		for(Record r : page.getList()){
			int type = r.getInt("msg_type") ;
			String typeStr = "" ;
			if(type == 0){
				typeStr = "[公告]";
			}
			else if(type == 1){
				typeStr = "[促销]";
			}
			else if(type == 2){
				typeStr = "[交易]";
			}
			else if(type == 3){
				typeStr = "[账户]";
			}
			else if(type == 4){
				typeStr = "[排名]";
			}
			else if(type == 5){
				typeStr = "[保险]";
			}
			r.set("msg_title", typeStr + r.getStr("msg_title"));
		}
		String field = "id|msg_type|msg_title|msg_content|msg_time";
		renderJson(JSONUtils.toPagedGridJSONStringUsingRecord(page, field));
	}
}
