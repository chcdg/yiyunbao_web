package com.maogousoft.wuliuweb.controller;

import com.jfinal.upload.UploadFile;
import com.maogousoft.wuliuweb.common.BaseController;
import com.maogousoft.wuliuweb.service.FileInfo;
import com.maogousoft.wuliuweb.service.ImageService;

/**
 * @author yangfan(kenny0x00@gmail.com) 2013-5-1 下午3:13:25
 */
public class PhotoController extends BaseController {

	public void upload() {
		UploadFile uf = getFile();
		FileInfo info = ImageService.saveFile(uf.getFileName(), uf.getFile());

		render(info.getVirtualUrl());
	}

}
