package com.maogousoft.wuliuweb.common.utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

public class ExcelUtil {

	/**
	 * 解析xls格式
	 * 
	 * @param filePath
	 * 上传文件路径
	 */
	public List<String[]> readXls(String filePath) {
		List<String[]> list = new ArrayList<String[]>();
		InputStream is;
		try {
			is = new FileInputStream(filePath);
			HSSFWorkbook hssfWorkbook = new HSSFWorkbook(is);
			// 循环工作表Sheet numSheet<1 表示只读第一个Sheet。如需全部读取 hssfWorkbook.getNumberOfSheets()
			for (int numSheet = 0; numSheet < 1; numSheet++) {
				HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(numSheet);
				if (hssfSheet == null) {
					continue;
				}
				// 循环行Row rowNum=表示从第3行开始遍历，跳过标题和第2行
				int lastRow = hssfSheet.getLastRowNum();
				for (int rowNum = 2; rowNum <= lastRow; rowNum++) {
					String[] str = new String[50];
					HSSFRow hssfRow = hssfSheet.getRow(rowNum);
					if (hssfRow == null) {
						continue;
					}
					// 循环列Cell
					for (int cellNum = 0; cellNum <= hssfRow.getLastCellNum(); cellNum++) {
						HSSFCell hssfCell = hssfRow.getCell(cellNum);
						if (hssfCell == null) {
							continue;
						}
						str[cellNum] = getCellFormatValue(hssfCell);
					}
					list.add(str);
				}
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 根据HSSFCell类型设置数据
	 * @param cell
	 * @return
	 */
	private String getCellFormatValue(HSSFCell cell) {
		String cellvalue = "";
		if (cell != null) {
			//判断当前Cell的Type
			switch (cell.getCellType()){
				//如果当前Cell的Type为NUMERIC 纯数字
				case HSSFCell.CELL_TYPE_NUMERIC:
					if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
						DecimalFormat df = new DecimalFormat("#.#");
						cellvalue = df.format(cell.getNumericCellValue());
					}
					else{
						DecimalFormat df = new DecimalFormat("#");
						//取得当前Cell的数值
//						cellvalue = String.valueOf(cell.getNumericCellValue());
						cellvalue = df.format(cell.getNumericCellValue());
					}
				case HSSFCell.CELL_TYPE_FORMULA: {
					//判断当前的cell是否为Date
					if (HSSFDateUtil.isCellDateFormatted(cell)) {
						//如果是Date类型则，转化为Data格式
						//方法1：这样子的data格式是带时分秒的：2011-10-12 0:00:00                    
						//cellvalue = cell.getDateCellValue().toLocaleString();
						
						//方法2：这样子的data格式是不带带时分秒的：2011-10-12
						Date date = cell.getDateCellValue();
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						cellvalue = sdf.format(date);
					}
					
					break;
				}
				case HSSFCell.CELL_TYPE_STRING://如果当前Cell的Type为STRING
					//取得当前的Cell字符串
					cellvalue = cell.getRichStringCellValue().getString();
					break;
					//默认的Cell值
				default:                
					cellvalue = " ";          
				}
			}
			else{
				cellvalue = "";  
			}
		return cellvalue;
	}
		
	
	public static void main(String[] args) {

	}

}
