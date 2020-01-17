/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {Component} from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  TouchableHighlight,
  ImageBackground,
  Button,
} from 'react-native';

import { RNAddShortcuts } from 'react-native-add-shortcuts';
import Icon from 'react-native-vector-icons/FontAwesome';

export default class App extends Component<{}> {
  _onPress = () => {
    let copy = (
      <Icon name="copy" size={30} color="#000000" family={'FontAwesome'} />
    );

    // RNAddShortcuts.AddPinnedShortcut({
    //   name: 'Copy',
    //   icon: copy,
    //   link: 'app:copy'
    // });

    RNAddShortcuts.AddDynamicShortcut({
      name: 'Copy',
      icon: copy,
      link: 'app:copy',
    });
  };

  render() {
    return (
      <ImageBackground
        source={require('./assets/dark.jpg')}
        style={styles.backgroundImage}>
        <Button
          title={'Tap Here'}
          onPress={() => {
            this._onPress()
          }}
        ></Button>
      </ImageBackground>
    );
  }
}

const styles = StyleSheet.create({
  backgroundImage: {
    flex: 1,
    width: null,
    height: null,
    flexDirection: 'column',
    justifyContent: 'space-between',
  },
  textStyle: {
    color: '#FFFFFF',
  },
  top: {
    flex: 1,
  },
  center: {
    flex: 1,
  },
  bottom: {
    flex: 1,
  },
});
