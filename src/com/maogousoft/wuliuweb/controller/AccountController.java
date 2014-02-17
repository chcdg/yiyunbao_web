package com.maogousoft.wuliuweb.controller;

import java.util.List;

import org.apache.commons.logging.LogFactory;

import org.apache.commons.logging.Log;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.upload.UploadFile;
import com.maogousoft.wuliuweb.common.BaseController;
import com.maogousoft.wuliuweb.common.utils.CookieUtil;
import com.maogousoft.wuliuweb.common.utils.DesCipher;
import com.maogousoft.wuliuweb.common.utils.JSONUtils;
import com.maogousoft.wuliuweb.domain.Business;
import com.maogousoft.wuliuweb.domain.Constant;
import com.maogousoft.wuliuweb.domain.User;
import com.maogousoft.wuliuweb.service.FileInfo;
import com.maogousoft.wuliuweb.service.ImageService;

/**
 * @author yangfan(kenny0x00@gmail.com) 2013-5-1 下午8:04:00
 */
public class AccountController extends BaseController {

	private static final Log log = LogFactory.getLog(AccountController.class);

	public void index() {
		int userId = getUserId();
		User user = User.dao.findById(userId);

		setAttr("user", user);
		render("account_index.ftl");
	}

	public void edit() {
		int userId = getUserId();
		User user = User.dao.findById(userId);
		setAttr("user", user);
		render("account_edit.ftl");
	}

	public void update() {
		try {
			int userId = getUserId();
			UploadFile uf = getFile("licence_photo");
			String name = getPara("name");
			String companyName = getPara("company_name");
			String telcom = getPara("telcom");
			String address = getPara("address");
			if(uf != null){
				FileInfo fileInfo = ImageService.saveFile(uf.getFileName(), uf.getFile());
				String licence_photo = fileInfo.getVirtualUrl();
				String sql = "update logistics_user set name = ? , company_name = ? ,licence_photo = ?,telcom=?,address=? where id = ?";
				Db.update(sql, name, companyName, licence_photo,telcom, address,userId);
			}	
			else{
				String sql = "update logistics_user set name = ? , company_name = ?,telcom=?,address=?  where id = ?";
				Db.update(sql, name, companyName,telcom, address, userId);
			}
			//修改姓名后，同时修改cookie
			DesCipher desCipher = new DesCipher(Constant.COOKIE_DES_KEY);
			String cookieCompanyName = desCipher.encrypt(companyName);
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_COMPANY, cookieCompanyName);
			renderHtml("修改成功");
		} catch (RuntimeException re) {
			log.error("修改失败",re);
			renderHtml("修改失败，请稍后再试");
		}
	}

	/**
	 * 
	 * @description  
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * May 18, 2013 6:53:03 PM
	 */
	public void updateForReg() {
		try {
			int userId = getUserId();
			UploadFile uf = getFile("licence_photo");
			String name = getPara("name");
			String companyName = getPara("company_name");
			String telcom = getPara("telcom");
			if(uf != null){
				FileInfo fileInfo = ImageService.saveFile(uf.getFileName(), uf.getFile());
				String licence_photo = fileInfo.getVirtualUrl();
				String sql = "update logistics_user set name = ? , company_name = ? ,licence_photo = ?,telcom=? where id = ?";
				Db.update(sql, name, companyName, licence_photo,telcom, userId);
			}	
			else{
				String sql = "update logistics_user set name = ? , company_name = ?,telcom=?  where id = ?";
				Db.update(sql, name, companyName,telcom,  userId);
			}
			//修改姓名后，同时修改cookie
			DesCipher desCipher = new DesCipher(Constant.COOKIE_DES_KEY);
			String cookieCompanyName = desCipher.encrypt(companyName);
			CookieUtil.addCookie(getResponse(), Constant.COOKIE_COMPANY, cookieCompanyName);
			setAttr("msg", "修改资料成功，请进入系统开始使用");
			render("reg_update_result.ftl");
		} catch (RuntimeException re) {
			log.error("修改失败",re);
			setAttr("msg", "修改失败，请进入系统中【我的易运宝】进行修改资料");
			render("reg_update_result.ftl");
		}
	}
	
	/**
	 * 
	 * @description 获取货主端详细评价
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Jun 2, 2013 1:40:49 PM
	 */
	public void getUserReply(){
		int userId = getUserId();
		String select = "SELECT a.* , b.name as driver_name ";
		String from = " from logistics_user_reply a left join logistics_driver b on a.driver_id = b.id " ;
		from += " left join logistics_order c on a.order_id = c.id" ;
		from += " where a.user_id = ? and a.status!=-1 order by a.id desc";
		List<Record> list = Db.find(select + from , userId);
		System.out.println(list);
		setAttr("list", list);
		render("account_reply.ftl");
	}
	
	/**
	 * 
	 * @description 账户记录 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Jun 2, 2013 2:26:39 PM
	 */
	public void business(){
		render("account_business.ftl");
	}
	
	/**
	 * 
	 * @description 获取账户记录 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Jun 2, 2013 2:26:11 PM
	 */
	public void getBusiness(){
		int userId = getUserId();
		String select = "SELECT a.*  ";
		String from = " from logistics_business a   where a.business_target = ? and a.account = ? order by a.id desc";
		Page<Record> page = Db.paginate(getPageIndex(), getPageSize(), select, from ,Business.TARGET_TYPE_USER , userId);
		renderText(JSONUtils.toPagedGridJSONStringUsingRecord(page, "id|business_target|account|business_type|business_amount|before_balance|after_balance|create_time"));
	}
}
