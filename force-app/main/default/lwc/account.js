import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateAccountName from '@salesforce/apex/AccountController.updateAccountName';

export default class AccountUpdater extends LightningElement {
    @track accountId = '';
    @track accountName = '';

    handleIdChange(event) {
        this.accountId = event.target.value;
    }

    handleNameChange(event) {
        this.accountName = event.target.value;
    }

    handleUpdate() {
        if (!this.accountId || !this.accountName) {
            this.showToast('Error', 'Please fill in all fields', 'error');
            return;
        }

        updateAccountName({ accountId: this.accountId, newName: this.accountName })
            .then(() => {
                this.showToast('Success', 'Account updated successfully', 'success');
                this.accountName = ''; // Clear input field
            })
            .catch(error => {
                this.showToast('Error updating record', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({ title, message, variant })
        );
    }
}
