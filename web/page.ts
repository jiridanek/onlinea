"use strict";

class Page {
	private page;
	constructor(page) {
		this.page = page;
	}
	querySelector(query) {
		return this.page.querySelector(query);
	}
	querySelectorAll(query) {
		return this.page.querySelectorAll(query);
	}
	reload() {
		this.page.location = this.page.location;
	}
}