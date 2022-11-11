import * as React from 'react';

function RandomAdvice() {
  return Math.random() > 0.5
    ? (
      <>
        Нажмите
        {' '}
        <kbd
          className={`
        tw-h-5 tw-items-center tw-justify-center tw-rounded tw-border tw-bg-white tw-font-semibold tw-block tw-leading-5 tw-mx-1.5 tw-px-1
        tw-border-gray-400 tw-text-gray-900
      `}
        >
          Esc
        </kbd>
        {' '}
        <span className="">для очистки или закрытия.</span>
      </>
    )
    : (
      <>
        Используйте
        <kbd
          className={`
        tw-h-5 tw-items-center tw-justify-center tw-rounded tw-border tw-bg-white tw-font-semibold tw-block tw-leading-5 tw-mx-1.5 tw-px-1
        tw-border-gray-400 tw-text-gray-900
      `}
        >
          ↑
        </kbd>
        и
        <kbd
          className={`
          tw-h-5 tw-items-center tw-justify-center tw-rounded tw-border tw-bg-white tw-font-semibold tw-block tw-leading-5 tw-mx-1.5 tw-px-1
          tw-border-gray-400 tw-text-gray-900
        `}
        >
          ↓
        </kbd>
        для выбора.
      </>
    );
}

export default React.memo(RandomAdvice);
