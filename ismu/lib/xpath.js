var xpath = {
	'evaluate': function(query, element) {
      return document.evaluate(query, element, null, XPathResult.ANY_TYPE, null); 
	},
	'xpathSelectorAll': function(query, element) {
		var v;
		var selected = [];
		var result = this.evaluate(query, element);
//		console.log(result);
//		console.log(query);
		while (result && (v = result.iterateNext()) !== null) {
			selected.push(v);
		}
		return selected;
	}
};