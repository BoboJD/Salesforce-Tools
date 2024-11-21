window.adjustModalHeight = modalElement => {
	modalElement.style.height = '';
	const wrapperBody = document.getElementById('wrapper-body');
	if(wrapperBody && modalElement){
		modalElement.style.height = wrapperBody.offsetHeight + 'px';
	}
};