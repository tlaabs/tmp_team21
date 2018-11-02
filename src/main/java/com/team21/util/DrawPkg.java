package com.team21.util;

public class DrawPkg {
	int[] xs;
	int[] ys;
	String color;
	
	public DrawPkg(int[] xs, int[] ys, String color){
		this.xs = xs;
		this.ys = ys;
		this.color = color;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public int[] getXs() {
		return xs;
	}
	public void setXs(int[] xs) {
		this.xs = xs;
	}
	public int[] getYs() {
		return ys;
	}
	public void setYs(int[] ys) {
		this.ys = ys;
	}
	
	
}
