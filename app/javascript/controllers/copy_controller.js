import { Controller } from "@hotwired/stimulus";

/**
 * Controller class who handle the copy of an elements
 */
export default class extends Controller {
  static targets = ["tag", "file", "token"];
  static timer = null;

  /**
   * An abstract function who take a callback to copy an element
   *
   * @param {Function} f_copy
   */
  copy_abstract(f_copy = () => {}) {
    this.reset_copy_notice();
    const to_copy = f_copy();
    window.setTimeout(() => {
      this.update_clipboard(to_copy);
    }, 100);
  }

  /**
   * Copy file link
   */
  copy_file_link() {
    this.copy_abstract(() => {
      const file = this.fileTarget;
      return file.dataset["src"];
    });
  }

  /**
   * Copy a token
   */
  copy_token() {
    this.copy_abstract(() => {
      const tokenElement = this.tokenTarget;
      return tokenElement.innerText;
    });
  }

  /**
   * Copy a tag
   */
  copy_tag() {
    this.copy_abstract(() => {
      const tagElement = this.tagTarget;
      return tagElement.innerText;
    });
  }

  /**
   * Update the clipboard with the message in params
   *
   * @param {String} message
   */
  update_clipboard(message) {
    navigator.clipboard.writeText(message).then(
      () => {
        this.update_copy_notice(["success", "appear"], ["hidden"]);
        this.destroy_copy_notice_after_seconds();
      },
      () => {
        this.update_copy_notice(["error", "appear"], ["hidden"]);
        this.destroy_copy_notice_after_seconds();
      }
    );
  }

  /**
   * Update the notice div and add as css class the string contains in add_class and
   * remove the one from remove_class
   *
   * @param {Array} add_class
   * @param {Array} remove_class
   */
  update_copy_notice(add_class = [], remove_class = []) {
    this.remove_other_notice();
    const copy_notice = document.querySelector(".copy-notice");
    remove_class.forEach((classe) => {
      copy_notice.classList.remove(classe);
    });
    add_class.forEach((classe) => {
      copy_notice.classList.add(classe);
    });
  }

  /**
   * Reset to default the div notice
   */
  reset_copy_notice() {
    if (this.timer) {
      window.clearTimeout(this.timer);
    }
    this.update_copy_notice(["hidden"], ["success", "error", "appear"]);
  }

  /**
   * Remove other rails notice
   *
   * @returns {void}
   */
  remove_other_notice() {
    const notice = document.querySelector("div.notice");
    if (!notice) {
      return;
    }
    for (let i = 0; i < notice.children.length; i++) {
      notice.children[i].innerHTML = "";
    }
    notice.classList.add("hidden");
  }

  /**
   * Remove the copy-notice after {seconds}
   *
   * @param {Integer} seconds
   */
  destroy_copy_notice_after_seconds(seconds = 5) {
    this.timer = window.setTimeout(() => {
      this.reset_copy_notice();
    }, seconds * 1000);
  }
}
