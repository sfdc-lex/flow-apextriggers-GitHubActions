import { createElement } from 'lwc';
import PreviewInvoice from 'c/previewInvoice';

describe('c-preview-invoice', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('renders component without errors', () => {
        // Arrange
        const element = createElement('c-preview-invoice', {
            is: PreviewInvoice
        });

        // Act
        document.body.appendChild(element);

        // Assert
        expect(element).toBeDefined();
    });
});