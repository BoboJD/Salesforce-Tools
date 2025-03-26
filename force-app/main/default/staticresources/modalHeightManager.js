window.adjustModalHeight = modalElement => {
	modalElement.style.height = '';
	const wrapperBody = document.getElementById('wrapper-body');
	if(wrapperBody && modalElement){
		modalElement.style.height = wrapperBody.offsetHeight + 'px';
	}
};

window.maximizeModalWidth = () => {
	const modalContainerElements = document.getElementsByClassName('modal-container');
	if(modalContainerElements){
		modalContainerElements[0].style.width = '90%';
		modalContainerElements[0].style.maxWidth = 'initial';
	}
};