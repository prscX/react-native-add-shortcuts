import React, { PureComponent } from "react";
import { ViewPropTypes, NativeModules, Platform } from "react-native";
import PropTypes from "prop-types";

import RNVectorHelper from './RNVectorHelper'

const { RNAddShortcuts } = NativeModules;

class AddShortcuts extends PureComponent {
    static propTypes = {
        ...ViewPropTypes
    };

    static defaultProps = {
    };

    static AddDynamicShortcut(props) {
        if (props.icon && props.icon.props) {
            props.icon = props.icon.props;

            let vectorIcon = RNVectorHelper.Resolve(props.icon.family, props.icon.name);
            props.icon = Object.assign({}, props.icon, vectorIcon);
        } else if (props.icon !== undefined) {
            props.icon = {
                name: props.icon,
                family: "",
                glyph: "",
                color: "",
                size: 0
            };
        }

        RNAddShortcuts.AddDynamicShortcut(
            props
        );
    }
  
    static AddPinnedShortcut(props) {
        if (props.icon && props.icon.props) {
            props.icon = props.icon.props;

            let vectorIcon = RNVectorHelper.Resolve(props.icon.family, props.icon.name);
            props.icon = Object.assign({}, props.icon, vectorIcon);
        } else if (props.icon !== undefined) {
            props.icon = {
                name: props.icon,
                family: "",
                glyph: "",
                color: "",
                size: 0
            };
        }

        RNAddShortcuts.AddPinnedShortcut(
            props
        );
    }
}

export { AddShortcuts as RNAddShortcuts }