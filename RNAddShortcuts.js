import React, { PureComponent } from "react";
import { ViewPropTypes, NativeModules, Platform } from "react-native";
import PropTypes from "prop-types";

import RNImageHelper from "react-native-image-helper";

const { RNAddShortcuts } = NativeModules;

let _initialAction = RNAddShortcuts && RNAddShortcuts.initialAction;

class AddShortcuts extends PureComponent {
  static propTypes = {
    ...ViewPropTypes
  };

  static defaultProps = {};

  static AddDynamicShortcut(props) {
    if (props.icon && props.icon.props) {
      props.icon = props.icon.props;

      let vectorIcon = RNImageHelper.Resolve(
        props.icon.family,
        props.icon.name
      );
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
      props,
      () => {
        props.onDone?.();
      },
      () => {
        props.onCancel?.();
      }
    );
  }

  static AddPinnedShortcut(props) {
    if (props.icon && props.icon.props) {
      props.icon = props.icon.props;

      let vectorIcon = RNImageHelper.Resolve(
        props.icon.family,
        props.icon.name
      );
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
      props,
      () => {
        props.onDone?.();
      },
      () => {
        props.onCancel?.();
      }
    );
  }

  static GetDynamicShortcuts(props) {
    RNAddShortcuts.GetDynamicShortcuts(
      shortcuts => {
        props.onDone?.(shortcuts);
      },
      () => {
        props.onCancel?.();
      }
    );
  }

  static RemoveAllDynamicShortcuts(props) {
    RNAddShortcuts.RemoveAllDynamicShortcuts(
      () => {
        props.onDone?.();
      },
      () => {
        props.onCancel?.();
      }
    );
  }

  static PopDynamicShortcuts(props) {
    RNAddShortcuts.PopDynamicShortcuts(
      props,
      () => {
        props.onDone?.();
      },
      () => {
        props.onCancel?.();
      }
    );
  }
        
  static PopInitialAction() {
    return new Promise((resolve) => {
      let initialAction = _initialAction;
      _initialAction = null;

      resolve(initialAction);
    })
  }
}

export { AddShortcuts as RNAddShortcuts };
