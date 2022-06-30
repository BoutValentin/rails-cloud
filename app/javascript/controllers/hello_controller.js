import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "tag", "file" ];
  static timer = null;

  copy_file_link() {
    this.reset_copy_notice();
    const file = this.fileTarget;
    const src = file.dataset['src'];
    // Delay for animation
    window.setTimeout(() => {
      this.update_clipboard(src);
    }, 100)
  }

  copy_tag() {
    this.reset_copy_notice();
    const tagElement = this.tagTarget;
    const tag = tagElement.innerText;
    // Delay for animation
    window.setTimeout(() => {
      this.update_clipboard(tag);
    }, 100)
  }

  update_clipboard(message) {
    navigator.clipboard.writeText(message).then(() => {
      this.update_copy_notice(['success', 'appear'], ['hidden']);
      this.destroy_copy_notice_after_seconds();
    }, () => {
      this.update_copy_notice(['error', 'appear'], ['hidden']);
      this.destroy_copy_notice_after_seconds();
    });
  }

  update_copy_notice(add_class = [], remove_class = []) {
    this.remove_other_notice();
    const copy_notice = document.querySelector(".copy-notice");
    remove_class.forEach(classe => {
      copy_notice.classList.remove(classe);
    });
    add_class.forEach(classe => {
      copy_notice.classList.add(classe)
    })
  }

  reset_copy_notice() {
    if (this.timer) {
      window.clearTimeout(this.timer);
    }
    this.update_copy_notice(['hidden'], ['success', 'error', 'appear']);
  }

  remove_other_notice() {
    const notice = document.querySelector('div.notice');
    if (!notice) {
      return;
    }
    for(let i = 0; i < notice.children.length; i++ ) {
      notice.children[i].innerHTML = ""
    }
    notice.classList.add('hidden');
  }

  destroy_copy_notice_after_seconds(seconds=5) {
    this.timer = window.setTimeout(() => {
      this.reset_copy_notice();
    }, seconds * 1000);
  }
}
