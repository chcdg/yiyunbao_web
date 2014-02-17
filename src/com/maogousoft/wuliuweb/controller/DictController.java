/**
 * @filename DictController.java
 */
package com.maogousoft.wuliuweb.controller;

import java.util.List;

import org.apache.commons.lang.StringUtils;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.maogousoft.wuliuweb.common.BaseController;
import com.maogousoft.wuliuweb.common.domain.MiniData;
import com.maogousoft.wuliuweb.common.utils.JSONUtils;
import com.maogousoft.wuliuweb.domain.Dict;

/**
 * @description 字典
 * @author shevliu
 * @email shevliu@gmail.com
 * Mar 15, 2013 9:01:34 PM
 */
public class DictController extends BaseController{

	public void list(){
		String type = getPara();
		setAttr("type", type);
		render("dict.ftl");
	}

	public void getListByType(){
		String s = getPara();
		List<Dict> list = Dict.dao.find("select * from logistics_dict where status = 0 and dict_type= ? order by id desc" , getPara());
		String json  = JSONUtils.toJSONString(list, "id|name|dict_type|dict_desc");
		renderText(json);
	}

	/**
	 *
	 * @description 根据上级编号查询
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 17, 2013 8:46:02 PM
	 */
	public void getByPid(){
		int pid = getParaToInt("id" , 0);
		getByPid(pid);
	}

	private void getByPid(int pid){
		String dictType = getPara("dict_type") ;
		String sql = "select * from logistics_dict where status = 0 and pid= " + pid ;
		if(StringUtils.isNotBlank(dictType)){
			sql += " and dict_type = '" + dictType + "'"  ;
		}
		sql += " order by id desc" ;
		List<Dict> list = Dict.dao.find(sql);
		for(Dict dict : list){
			dict.put("isLeaf", false);
			dict.put("expanded", false);
		}
		String json  = JSONUtils.toJSONString(list, "id|name|dict_type|dict_desc|pid|isLeaf|expanded");
		renderText(json);
	}

	public void getArea(){
		int pid = getParaToInt("id" , 0);
		String sql = "select * from logistics_area where status = 0 and pid= " + pid + " order by id";
		List<Record> list = Db.find(sql);
		for(Record area : list){
			if(area.getInt("deep") <3){
				area.set("isLeaf", false);
				area.set("expanded", false);
			}else{
				area.set("isLeaf", true);
				area.set("expanded", true);
			}
		}
		String json  = JSONUtils.toJSONStringUsingRecord(list, "id|name|short_name|pid|isLeaf|expanded");
		renderText(json);

	}

	public void getProvinceList() {
		String sql = "select * from logistics_area where status = 0 and deep=1 order by id";
		List<Record> provinceList = Db.find(sql);
		String json  = JSONUtils.toJSONStringUsingRecord(provinceList, "id|name|short_name|pid");
		renderText(json);
	}

	public void getCityList() {
		int province_id = getParaToInt("province_id", 0);
		String sql = "select * from logistics_area where status = 0 and deep=2 and pid=? order by id";
		List<Record> provinceList = Db.find(sql,province_id);
		String json  = JSONUtils.toJSONStringUsingRecord(provinceList, "id|name|short_name|pid");
		renderText(json);
	}

	public void getDistrictList() {
		int city_id = getParaToInt("city_id", 0);
		String sql = "select * from logistics_area where status = 0 and deep=3 and pid=? order by id";
		List<Record> provinceList = Db.find(sql,city_id);
		String json  = JSONUtils.toJSONStringUsingRecord(provinceList, "id|name|short_name|pid");
		renderText(json);
	}

	/**
	 *
	 * @description 查询所有车型
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 17, 2013 8:47:03 PM
	 */
	public void getAllCarType(){
		getAllByType(Dict.TYPE_CAR);
	}

	/**
	 *
	 * @description 查询所有货物类型
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 17, 2013 11:06:32 PM
	 */
	public void getAllCargoType(){
		getAllByType(Dict.TYPE_CARGO);
	}

	/**
	 * 查询所有运输方式
	 */
	public void getAllShipType(){
		getAllByType(Dict.TYPE_SHIP_TYPE);
	}
	
	/**
	 * 
	 * @description 查询所有保险包装类型 
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * 2013年9月4日 下午11:28:38
	 */
	public void getAllInsurancePackageType(){
		getAllByType(Dict.TYPE_INSURANCE_PACKAGE_TYPE);
	}
	
	

	/**
	 *
	 * @description 根据类型查询
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 17, 2013 7:30:32 PM
	 */
	private void getAllByType(String type){
		List<Dict> list = Dict.dao.find("select * from logistics_dict where status = 0 and dict_type= ? order by id " , type);
		Dict first = new Dict();
		first.put("id", "");
		first.put("name", "--请选择--");
		String json  = JSONUtils.toJSONString(list, "id|name|dict_type|dict_desc");
		renderText(json);
	}

	public void save(){
		String type=getPara("dict_type");
		System.out.println("type.... " + type);
		MiniData data = getMiniData();
		Record record = data.getRecord() ;
		record.set("dict_type", type);
		if(data.getPageState().equals(MiniData.ADD)){
			Db.save("logistics_dict", record);
		}
		else{
			Db.update("update logistics_dict set name= ? , dict_desc=? where id = ? " , record.getStr("name") , record.getStr("dict_desc") , record.getInt("id")) ;
		}
	}

	public void delete(){
		int id = getParaToInt();
		Db.update("update logistics_dict set status = -1 where id = ? " , id);
	}

	/**
	 *
	 * @description 地区树
	 * @author shevliu
	 * @email shevliu@gmail.com
	 * Mar 18, 2013 10:37:10 PM
	 */
	public void areaTree(){
		render("area_tree.ftl");
	}
}
