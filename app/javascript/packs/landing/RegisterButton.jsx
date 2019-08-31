import React from 'react';
import { Fragment } from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'antd';
import { FormattedMessage } from 'react-intl';
import { ModalConsumer } from './ModalContext';

class RegisterButton extends React.Component {

    constructor(props) {
        super(props)
    }

    render() {
        return (
            <ModalConsumer>
                {(showModal) => (
                    <Fragment>
                        <Button {...this.props} onClick={showModal}>
                            {this.props.children}
                        </Button>
                    </Fragment>
                )}
            </ModalConsumer>
        );
    }
}

export default RegisterButton;