import { Dialog, Transition } from '@headlessui/react';
import { Fragment, useEffect, useState } from 'react';
import * as React from 'react';
import { XMarkIcon } from '@heroicons/react/24/solid';
import { useForm } from 'react-hook-form';
import { motion, AnimatePresence } from 'framer-motion';
import { FloatingOverlay } from '@floating-ui/react-dom-interactions';
import axios from './system/Axios';

export default function Complain({
  opened, close, entitiesMentionId, entityId, mentionId,
}: {
  opened: boolean,
  close: () => boolean,
  entityId?: string,
  entitiesMentionId?: string
  mentionId?: string
}) {
  const {
    register, reset, handleSubmit, setError, formState: { errors },
  } = useForm();
  const [submitted, setSubmitted] = useState(false);

  const onSubmit = (data) => {
    axios.post('/api/complains', {
      ...data,
      ...{
        data: {
          entity_id: entityId,
          mention_id: mentionId,
          entities_mentionId: entitiesMentionId,
        },
      },
    })
      .then((response) => {
        setSubmitted(true);
      })
      .catch((error) => {
        setError('text', { type: 'custom', message: 'Произошла непредвиденная ошибка' });
      });
  };

  const resetForm = () => {
    reset();
    setSubmitted(false);
  };

  return (
    <Transition appear show={opened} as={Fragment}>
      <Dialog
        as="div"
        className="tw-relative tw-z-40"
        onClose={() => {
        }}
      >
        <Transition.Child
          afterLeave={() => resetForm()}
          as={Fragment}
          enter="tw-ease-out tw-duration-300"
          enterFrom="tw-opacity-0"
          enterTo="tw-opacity-100"
          leave="tw-ease-in tw-duration-200"
          leaveFrom="tw-opacity-100"
          leaveTo="tw-opacity-0"
        >
          {/* <FloatingOverlay className="tw-bg-slate-500/50" /> */}
          <Dialog.Overlay className="tw-fixed tw-inset-0 tw-bg-slate-500/50" />
        </Transition.Child>

        <div className="tw-fixed tw-inset-0 tw-overflow-y-auto">
          <div className="tw-flex tw-min-h-full tw-items-center tw-justify-center tw-p-4 tw-text-center">
            <Transition.Child
              as={Fragment}
              enter="tw-ease-out tw-duration-300"
              enterFrom="tw-opacity-0 tw-scale-95"
              enterTo="tw-opacity-100 tw-scale-100"
              leave="tw-ease-in tw-duration-200"
              leaveFrom="tw-opacity-100 tw-scale-100"
              leaveTo="tw-opacity-0 tw-scale-95"
            >
              <Dialog.Panel
                className="tw-w-full tw-max-w-md tw-transform tw-overflow-hidden tw-rounded-2xl tw-bg-white tw-p-6 tw-text-left tw-align-middle tw-shadow-xl tw-transition-all"
              >
                <Dialog.Title
                  as="h3"
                  className="tw-flex tw-text-lg tw-font-medium tw-leading-6 tw-text-gray-900"
                >
                  <div>Репорт</div>
                  <div>
                    <div className="tw-absolute tw-top-0 tw-right-0 tw-pt-4 tw-pr-4">
                      <button
                        type="button"
                        className="tw-bg-white tw-rounded-md tw-text-gray-400 hover:tw-text-gray-500
                          focus:tw-outline-none focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-indigo-300"
                        onClick={() => close()}
                      >
                        <span className="tw-sr-only">Закрыть</span>
                        <XMarkIcon className="tw-h-6 tw-w-6" aria-hidden="true" />
                      </button>
                    </div>
                  </div>
                </Dialog.Title>
                {submitted
                  ? (
                    <Transition
                      appear
                      as={Fragment}
                      enter="tw-ease-out tw-duration-300 tw-delay-100"
                      enterFrom="tw-opacity-0"
                      enterTo="tw-opacity-100"
                      leave="tw-ease-in tw-duration-200"
                      leaveFrom="tw-opacity-100"
                      leaveTo="tw-opacity-0"
                    >
                      <div className="tw-flex tw-flex-col tw-content-center tw-text-green-600 tw-my-14 tw-items-center tw-gap-8">
                        <AnimatePresence>
                          <motion.svg
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            strokeWidth="1.5"
                            stroke="currentColor"
                            className="tw-w-10 tw-h-10"
                          >
                            <motion.path
                              initial={{ pathLength: 0, opacity: 0 }}
                              animate={{
                                pathLength: 1,
                                opacity: 1,
                                transition: {
                                  pathLength: { type: 'spring', duration: 1, bounce: 0 },
                                  opacity: { duration: 0.1 },
                                },
                              }}
                              strokeLinecap="round"
                              strokeLinejoin="round"
                              d="M4.5 12.75l6 6 9-13.5"
                            />
                          </motion.svg>
                        </AnimatePresence>

                        <div className="tw-text-slate-500 tw-text-lg tw-text-center">
                          Благодарим вас за отправку отчета.
                        </div>
                      </div>
                    </Transition>
                  )
                  : (
                    <form
                      className="tw-mb-0"
                      onSubmit={handleSubmit(onSubmit)}
                    >
                      <div className="tw-my-5">
                        <textarea
                          {...register('text', { required: true })}
                          rows={4}
                          className={`
                            ${errors.text && 'tw-bg-yellow-50'}
                            ${errors.text ? 'focus:tw-ring-red-300' : 'focus:tw-ring-indigo-300'}
                            ${errors.text ? 'focus:tw-border-red-300' : 'focus:tw-border-indigo-300'}
                            tw-block tw-w-full sm:tw-text-sm tw-border-gray-300 tw-rounded-md`}
                          defaultValue=""
                        />
                        {errors.text
                            && (
                            <div className="tw-text-sm tw-mt-2 tw-text-red-400">
                              { errors.text.message.toString() || 'Поле обязательно для заполнения' }
                            </div>
                            )}
                        <div className="tw-text-xs tw-mt-2 tw-text-gray-500">
                          Сообщайте пожалуйста нам о неправильных данных, дубликатах, нарушениях авторских прав и
                          т.д. через эту форму.
                        </div>
                      </div>

                      <div className="tw-mt-4">
                        <button
                          type="submit"
                          className="tw-w-full tw-inline-flex tw-justify-center tw-rounded-md tw-border
                                tw-border-transparent  tw-px-4 tw-py-2 tw-bg-red-600 tw-text-base
                                tw-font-medium tw-text-white hover:tw-bg-red-700 focus:tw-outline-none
                                focus:tw-ring-2 focus:tw-ring-offset-2 focus:tw-ring-red-500 sm:tw-w-auto sm:tw-text-sm"
                        >
                          Отправить
                        </button>
                      </div>
                    </form>
                  )}
              </Dialog.Panel>
            </Transition.Child>
          </div>
        </div>
      </Dialog>
    </Transition>
  );
}
