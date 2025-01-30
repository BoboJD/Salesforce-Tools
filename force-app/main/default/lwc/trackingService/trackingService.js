import commitTracking from '@salesforce/apex/TrackingServiceController.commitTracking';

const addTracking = functionality => {
	commitTracking({ functionality });
};

export { addTracking };