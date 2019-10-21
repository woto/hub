import React, { Fragment } from 'react';
import { Button } from 'antd';
import { withRouter } from 'react-router-dom';
import { AuthConsumer } from '../../shared/AuthContext';

const LoginButtonWithRouter = withRouter((props) => {
  const { auth, history } = props;
  const redirect = (() => {
    if (auth.isAuthorized) {
      history.push('/dashboard');
    } else {
      history.push('/login');
    }
  });

  return (
    <Button jid="login-button" onClick={redirect} className={props.className} type={props.type}>
      {props.children}
    </Button>
  );
});

// A component may consume multiple contexts
const LoginButton = (props) => (
  <AuthConsumer>
    {(auth) => (
      <LoginButtonWithRouter auth={auth} className={props.className} type={props.type}>
        {props.children}
      </LoginButtonWithRouter>
    )}
  </AuthConsumer>
);

export default LoginButton;
