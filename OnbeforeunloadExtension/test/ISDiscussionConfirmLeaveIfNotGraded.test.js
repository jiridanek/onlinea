/**
 * Created by jirka on 9/15/14.
 */

// http://confluence.jetbrains.com/display/WI/Running+JavaScript+tests+with+Karma

var getDoc = function (name) {
    var html = window.__html__[name];
    var parser = new DOMParser();
    var doc = parser.parseFromString(html, "text/html");
    return doc;
}

describe("A test suite", function() {
    beforeEach(function() { });
    afterEach(function() { });
    it('should stop unload myNotGradedPost.html', function() {
        var doc = getDoc('test/myNotGradedPost.html');
        expect(shouldStopUnload(doc)).equal(true);
    });
    it('should not stop unload myNotGradedPostSaved.html', function() {
        var doc = getDoc('test/myNotGradedPostSaved.html');
        expect(shouldStopUnload(doc)).equal(false);
    });
    it('should not stop unload myGradedPost.html', function() {
        var doc = getDoc('test/myGradedPost.html');
        expect(shouldStopUnload(doc)).equal(false);
    });
});