package com.maogousoft.wuliuweb.domain;

import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.maogousoft.wuliuweb.common.exception.BusinessException;

/**
 * @author yangfan(kenny0x00@gmail.com) 2013-4-8 下午10:40:16
 */
public class Area extends BaseModel<Area> {

	private static final long serialVersionUID = 1L;

	public static final int DEEP_COUNTRY = 0;
	public static final int DEEP_PROVINCE = 1;
	public static final int DEEP_CITY = 2;
	public static final int DEEP_DISTRICT = 3;

	public static final Area dao = new Area();

	public static Area getAreaByIdWithCache(final Integer areaId) {
		String sql = "select id,pid,name,short_name,deep,status from logistics_area where id=? and status=0";
		Area area = Area.dao.findFirstByCache(Constant.CACHE_AREA, areaId, sql, areaId);
		return area;
	}

	public static void fillAreaToRecord(Record record, String idColumn, String strColumn) {
		final Integer areaId = record.getInt(idColumn);
		if (areaId != null) {
			Area area = Area.getAreaByIdWithCache(areaId);
			if (area != null) {
				String strValue = area.getStr("short_name");
				record.set(strColumn, strValue);
			} else {
				record.set(strColumn, null);
			}
		}
	}

	public static void fillAreaToModel(Model<?> model, String idColumn, String strColumn) {
		final Integer areaId = model.getInt(idColumn);
		if (areaId != null) {
			Area area = Area.getAreaByIdWithCache(areaId);
			if (area != null) {
				String strValue = area.getStr("short_name");
				model.put(strColumn, strValue);
			} else {
				model.put(strColumn, null);
			}
		}
	}

	public int getProvinceId() {
		final int deep = this.getInt("deep");
		if(deep == DEEP_COUNTRY) {
			return this.getInt("id");
		}
		if(deep == DEEP_PROVINCE) {
			return this.getInt("id");
		}
		if(deep == DEEP_CITY) {
			return this.getInt("pid");
		}
		if(deep == DEEP_DISTRICT) {
			//区县
			Area city = Area.getAreaByIdWithCache(this.getInt("pid"));
			if(city == null) {
				return -1;//无效的上级城市pid
			}
			if(city.getInt("deep") != DEEP_CITY) {
				throw new BusinessException("无效的地区数据,id=" + city.getInt("id"));
			}
			return city.getProvinceId();
		}
		return -1;
	}

	public int getCityId() {
		final int deep = this.getInt("deep");
		if(deep == DEEP_COUNTRY) {
			return -1;
		}
		if(deep == DEEP_PROVINCE) {
			return -1;
		}
		if(deep == DEEP_CITY) {
			return this.getInt("id");
		}
		if(deep == DEEP_DISTRICT) {
			//区县
			return this.getInt("pid");
		}
		return -1;
	}

	public int getDistrictId() {
		final int deep = this.getInt("deep");
		if(deep == DEEP_COUNTRY) {
			return -1;
		}
		if(deep == DEEP_PROVINCE) {
			return -1;
		}
		if(deep == DEEP_CITY) {
			return -1;
		}
		if(deep == DEEP_DISTRICT) {
			//区县
			return this.getInt("id");
		}
		return -1;
	}
	
	public static Area getAreaByName(String name){
		String sql = "select id from logistics_area where short_name = ?";
		return Area.dao.findFirst(sql, name);
	}
}
