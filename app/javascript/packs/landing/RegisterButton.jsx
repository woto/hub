import React from 'react';
import { Fragment } from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'antd';
import { FormattedMessage } from 'react-intl';
import { RegisterModalConsumer } from './RegisterModal';

class RegisterButton extends React.Component {

    constructor(props) {
        super(props)
    }

    render() {
        return (
            <RegisterModalConsumer>
                {(showModal) => (
                    <Fragment>
                        <Button {...this.props} onClick={showModal}>
                            {this.props.children}
                        </Button>
                    </Fragment>
                )}
            </RegisterModalConsumer>
        );
    }
}

export default RegisterButton;