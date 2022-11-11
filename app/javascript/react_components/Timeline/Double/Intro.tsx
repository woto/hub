import * as React from "react"
import Wrapper from "../Wrappers/Wrapper";
import Operation from '../Wrappers/Operation';
import Text from '../../Entities/Text';

export default function Intro(props: { intro: any }) {
  if (!props.intro) return;

  return (
    <Wrapper title='описание'>
      {props.intro.add && <Operation type='append'><Text title={props.intro.add}></Text></Operation>}
      {props.intro.remove && <Operation type='remove'><Text title={props.intro.remove}></Text></Operation>}
    </Wrapper>
  )
}
