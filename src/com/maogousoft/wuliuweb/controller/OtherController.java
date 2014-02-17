/**
 * @filename OtherController.java
 */
package com.maogousoft.wuliuweb.controller;

import com.maogousoft.wuliuweb.common.BaseController;
import com.maogousoft.wuliuweb.domain.User;

/**
 * @description 其他
 * @author shevliu
 * @email shevliu@gmail.com
 * Apr 30, 2013 10:55:12 PM
 */
public class OtherController extends BaseController{

	public void index(){
		User user = User.dao.findById(getUserId());
		setAttr("user", user);
		render("other.ftl");
	}
}
