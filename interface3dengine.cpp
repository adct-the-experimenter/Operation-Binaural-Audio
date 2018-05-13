#include "interface3dengine.h"

Interface3DEngine::Interface3DEngine(QObject* parent)
{
    m_targetProperty = nullptr;
}

Interface3DEngine::~Interface3DEngine()
{
    m_targetProperty = nullptr;
}

//function to set target
void Interface3DEngine::setTarget(const QQmlProperty &prop){ m_targetProperty = prop; }

void Interface3DEngine::initView()
{


}
