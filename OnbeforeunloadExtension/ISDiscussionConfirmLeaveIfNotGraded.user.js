// ==UserScript==
// @name           IS MU Confirm Leave If Not Graded Posts
// @author         Jiri Danek <dnk@mail.muni.cz>
// @description    Zobrazí varovný dialog, pokud se pokusíte zavřít nebo jinak opustit stránku, ve které máte neobodovaný příspěvek.
// @match          https://is.muni.cz/auth/df/*
// @match          https://is.muni.cz/auth/diskuse/diskusni_forum_indiv.pl*
// @namespace      https://is.muni.cz/auth/web/374368
// @run-at         document-end
// @version        1.0.2
// ==/UserScript==

/*

 Copyright 2014 Jiri Danek

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 */

// http://www.chromium.org/developers/design-documents/user-scripts

//(function() {
    "use strict";

    var CONFIG = {
        "COMMAND_CS": 'Hodnotit do poznámkového bloku',
        "COMMAND_EN": 'Enter evaluation into a notebook',
        "CONFIRM_SUCCESS_CS": 'Úspěšně uloženo.',
        "CONFIRM_SUCCESS_EN": 'Saved successfully.',
        "WARN_NO_CHANGES_CS": 'Žádná změna.',
        "WARN_NO_CHANGES_EN": 'No changes made.',

        "WARNING_MSG": 'Na stránce ještě jsou neobodované příspěvky!'
    };

    /**
     * @param hodn_pri {HTMLDivElement}
     * @returns {boolean}
     */
    var isNotGraded = function(hodn_pri) {
        var commandLink = hodn_pri.querySelector('a');
        var hasCommandLink = (commandLink != null &&
            (commandLink.text == CONFIG.COMMAND_CS || commandLink.text == CONFIG.COMMAND_EN));

        var msgBox = hodn_pri.querySelector('div.zdurazneni.potvrzeni > h3, div.zdurazneni.upozorneni > h3');
        var hasConfirmSuccessHeadline = (msgBox != null &&
            (msgBox.textContent == CONFIG.CONFIRM_SUCCESS_CS || msgBox.textContent == CONFIG.CONFIRM_SUCCESS_EN));
        var hasNoChangesHeadline = (msgBox != null &&   // impossible to say, but it's reasonable to guess post is graded
            (msgBox.textContent == CONFIG.WARN_NO_CHANGES_CS || msgBox.textContent == CONFIG.WARN_NO_CHANGES_EN));

        return (hasCommandLink && !hasConfirmSuccessHeadline && !hasNoChangesHeadline);
    };
    
    /**
     * @param hodn_pri {HTMLDivElement}
     * @returns {boolean}
     */
    var isBeingGraded = function(hodn_pri) {
        var textarea = hodn_pri.querySelector('textarea');

        return (textarea !== null);
    };

    /**
     * document {Document}
     * @returns {boolean}
     */
    var shouldStopUnload = function(document) {
        var hodn_pris = document.querySelectorAll('#pr_vse > div > div.hodn_pri');
        for (var i = 0; i < hodn_pris.length; i++) {
            if (isNotGraded(hodn_pris[i]) || isBeingGraded(hodn_pris[i])) {
                return true;
            }
        }
        return false;
    };

    window.addEventListener("beforeunload", function (e) {
        if (shouldStopUnload(document)) {
            // https://developer.mozilla.org/en-US/docs/Web/Events/beforeunload
            var confirmationMessage = CONFIG.WARNING_MSG;
            (e || window.event).returnValue = confirmationMessage;     //Gecko + IE
            return confirmationMessage;                                //Webkit, Safari, Chrome etc.
        }
        return null;
    });
//})();