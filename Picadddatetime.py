#!/usr/bin/python
#coding=utf8
import datetime
from PIL import Image, ImageFont, ImageDraw
import sys
#import os

def addText(image_path, text):
#	(filepath, tempfilename) = os.path.split(image_path)
#	(filename, extension) = os.path.splitext(tempfilename)
#	print(filepath,tempfilename,filename,extension)
	im = Image.open(image_path)
	width, height = im.size
#	print(width, height)
	font_size = int(height/25)
	if font_size > 24 :
		font_size = 24
	if font_size < 10 :
		font_size = 10
#	/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf
	ttfont = ImageFont.truetype('DejaVuSans.ttf', font_size)
	draw = ImageDraw.Draw(im)
	draw.text((2, 2), text, 'red', font= ttfont)
	draw.text((0, 0), text, font= ttfont)
	im.save(image_path)
	im.close()
	
if __name__ == '__main__':
	if len(sys.argv)<2 :
		print("need a pic file arguement")
	else:
		nowTime = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
		addText(sys.argv[1], nowTime)
