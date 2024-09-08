import { Controller } from "@hotwired/stimulus"
import "cropper"
let fileBlob = null
export default class extends Controller {
  static targets = [ "avatarWrapper", "updateAvatarButton" ]

  loadCropper(img){
    const cropper = new Cropper(img, {
      aspectRatio: 1/1,
      viewMode: 2,
      minContainerHeight: 200,
      dragMode: 'move',
      crop(){
        const canvas = cropper.getCroppedCanvas()
        canvas.toBlob((blob) => {
          fileBlob = new File([blob], "cropped-avatar.jpg", {type: "image/jpeg"})
        })
      }
    })
  }

  loadImage(event){
    const reader = new FileReader()
    reader.onload = (load_event) => {
      let img = new Image()

      img.onload = () => {
        this.avatarWrapperTarget.innerHTML = ""
        this.avatarWrapperTarget.replaceChildren(img)
        this.updateAvatarButtonTarget.disabled = false
        this.loadCropper(img)
      }

      img.src = load_event.target.result
      img.classList.add("cropper-image")
      img.style.height = "auto"
      img.style.width = "100%"
      img.id = "new-avatar-image"
    }

    reader.readAsDataURL(event.target.files[0])
  }

  updateAvatar(){
    this.updateAvatarButtonTarget.disabled = true
    const container = new DataTransfer()
    container.items.add(fileBlob)
    document.getElementById("avatarImageInput").files = container.files
    this.element.submit()
  }

  clearAvatarForm(){
    setTimeout(() => {
      document.getElementById("avatarImageInput").value = ""
      this.avatarWrapperTarget.innerHTML = ""
    }, 500);
  }
}
