import { WebRentMePage } from './app.po';

describe('web-rent-me App', () => {
  let page: WebRentMePage;

  beforeEach(() => {
    page = new WebRentMePage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
