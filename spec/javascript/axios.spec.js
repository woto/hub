import './__mocks__/fakeJsdomPage';
import './__mocks__/fakeLocalStorage';
import mockAxios from '../../app/javascript/shared/Axios';

jest.mock('axios');

it('Adds X-CSRF-Token to headers if it present on a page in meta', () => {
  const csrfToken = mockAxios.defaults.headers.common['X-CSRF-Token'];
  expect(csrfToken).toEqual('vflmXQIrdvEFNilf2cr7kJZZrKtSb073PLq/KH3RAntRy3UCEKCcV3vIL20t90D9vop5NvxAUUP3WlTiMOEGGA==');
});

it('Adds access_token to headers if it present in localStorage', () => {
  const accessToken = mockAxios.defaults.headers.common.Authorization;
  expect(accessToken).toEqual('Bearer N_snPFmP_XF9R9TWOXiVvWY5PcfmZOWQ7dLUagwVzwg');
});

it('Mocks axios request', () => {
  const resp = { data: 'data' };
  mockAxios.get.mockResolvedValue(resp);
  mockAxios.get('/test').then((data) => {
    expect(data).toEqual({ data: 'data' });
  });

  expect(mockAxios.get).toHaveBeenCalledWith('/test');
});
