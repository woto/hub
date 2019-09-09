import React from "react";
import Axios from "../../shared/axios";
import { BrowserRouter as Router, Route, Link } from "react-router-dom";

export default class Proxy extends React.Component {
    async componentDidMount() {
        const key = this.props.match.params.id;
        const response = await Axios.patch(`/api/v1/users/binds/${key}`)
        console.log(response.data)
        localStorage.setItem('access_token', response.data.access_token)
    }

    render() {
        return(
            <div>TODO: stylize a redirect web page to look not like advertisement redirect :)</div>
        )
    }
}