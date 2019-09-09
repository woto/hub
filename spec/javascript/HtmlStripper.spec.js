import HtmlStripper from '../../app/javascript/packs/HtmlStripper'

test('strips html tags from a string', () => {
  const htmlStripper = new HtmlStripper({
    html: '<p>test</p>'
  })
  expect(htmlStripper.stripHtml()).toEqual('test')
})